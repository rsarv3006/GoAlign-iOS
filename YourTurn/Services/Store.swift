import Foundation
import StoreKit

let goAlignMembershipId = "goalign.membership"
let goAlignLifetimeUnlockId = "lifetime.unlock"

public enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    var updateListenerTask: Task<Void, Error>?

    @Published var goAlignMembershipPurchase: Product?
    @Published var hasPurchasedMembership: Bool = false
    @Published var goAlignLifetimeUnlock: Product?
    @Published var hasPurchasedLifetimeUnlock: Bool = false

    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    @MainActor
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: [goAlignMembershipId, goAlignLifetimeUnlockId])

            for product in storeProducts {
                if product.type == .autoRenewable {
                    goAlignMembershipPurchase = product
                } else if product.type == .nonConsumable {
                    goAlignLifetimeUnlock = product
                }
            }
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                if transaction.productType == .autoRenewable, transaction.productID == goAlignMembershipId {
                    hasPurchasedMembership = true
                } else if transaction.productType == .nonConsumable, transaction.productID == goAlignLifetimeUnlockId {
                  hasPurchasedLifetimeUnlock = true
                } else {
                    print("Unknown product type or id")
                }
            } catch {
                print("Failed to verify transactions")
            }
        }
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            await updateCustomerProductStatus()

            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            print("Purchase cancelled")
            return nil
        default:
            print("Purchase failed")
            return nil
        }
    }
}

let store = Store()
