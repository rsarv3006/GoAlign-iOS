import Foundation
import StoreKit

let goAlignMembershipId = "goalign.membership"

public enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    var updateListenerTask: Task<Void, Error>?

    @Published var goAlignMembershipPurchase: Product?
    @Published var hasPurchasedUnlockAdvancedEquations: Bool = false

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
        print("Requesting products")
        do {
            let storeProducts = try await Product.products(for: [goAlignMembershipId])

            if storeProducts.count > 0 {
                goAlignMembershipPurchase = storeProducts[0]
                hasPurchasedUnlockAdvancedEquations = true
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

                if transaction.productType == .nonConsumable, transaction.productID == goAlignMembershipId {
                    hasPurchasedUnlockAdvancedEquations = true
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
