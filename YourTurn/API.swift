// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class TasksByAssignedUserIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query TasksByAssignedUserId($userId: String!) {
      getTasksByAssignedUserId(userId: $userId) {
        __typename
        taskId
        createdAt
        taskName
        notes
        startDate
        endDate
        requiredCompletionsNeeded
        completionCount
        intervalBetweenWindows
        windowLength
        teamId
        assignedUser {
          __typename
          userId
          createdAt
          username
          email
          isActive
        }
        creator {
          __typename
          userId
          createdAt
          username
          email
          isActive
        }
        status
      }
    }
    """

  public let operationName: String = "TasksByAssignedUserId"

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTasksByAssignedUserId", arguments: ["userId": GraphQLVariable("userId")], type: .nonNull(.list(.nonNull(.object(GetTasksByAssignedUserId.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTasksByAssignedUserId: [GetTasksByAssignedUserId]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTasksByAssignedUserId": getTasksByAssignedUserId.map { (value: GetTasksByAssignedUserId) -> ResultMap in value.resultMap }])
    }

    public var getTasksByAssignedUserId: [GetTasksByAssignedUserId] {
      get {
        return (resultMap["getTasksByAssignedUserId"] as! [ResultMap]).map { (value: ResultMap) -> GetTasksByAssignedUserId in GetTasksByAssignedUserId(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetTasksByAssignedUserId) -> ResultMap in value.resultMap }, forKey: "getTasksByAssignedUserId")
      }
    }

    public struct GetTasksByAssignedUserId: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TaskModel"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("taskId", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("taskName", type: .nonNull(.scalar(String.self))),
          GraphQLField("notes", type: .scalar(String.self)),
          GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .scalar(String.self)),
          GraphQLField("requiredCompletionsNeeded", type: .nonNull(.scalar(Double.self))),
          GraphQLField("completionCount", type: .nonNull(.scalar(Double.self))),
          GraphQLField("intervalBetweenWindows", type: .nonNull(.scalar(Double.self))),
          GraphQLField("windowLength", type: .nonNull(.scalar(Double.self))),
          GraphQLField("teamId", type: .nonNull(.scalar(String.self))),
          GraphQLField("assignedUser", type: .nonNull(.object(AssignedUser.selections))),
          GraphQLField("creator", type: .nonNull(.object(Creator.selections))),
          GraphQLField("status", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(taskId: String, createdAt: String, taskName: String, notes: String? = nil, startDate: String, endDate: String? = nil, requiredCompletionsNeeded: Double, completionCount: Double, intervalBetweenWindows: Double, windowLength: Double, teamId: String, assignedUser: AssignedUser, creator: Creator, status: String) {
        self.init(unsafeResultMap: ["__typename": "TaskModel", "taskId": taskId, "createdAt": createdAt, "taskName": taskName, "notes": notes, "startDate": startDate, "endDate": endDate, "requiredCompletionsNeeded": requiredCompletionsNeeded, "completionCount": completionCount, "intervalBetweenWindows": intervalBetweenWindows, "windowLength": windowLength, "teamId": teamId, "assignedUser": assignedUser.resultMap, "creator": creator.resultMap, "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var taskId: String {
        get {
          return resultMap["taskId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "taskId")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var taskName: String {
        get {
          return resultMap["taskName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "taskName")
        }
      }

      public var notes: String? {
        get {
          return resultMap["notes"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "notes")
        }
      }

      public var startDate: String {
        get {
          return resultMap["startDate"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "startDate")
        }
      }

      public var endDate: String? {
        get {
          return resultMap["endDate"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "endDate")
        }
      }

      public var requiredCompletionsNeeded: Double {
        get {
          return resultMap["requiredCompletionsNeeded"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "requiredCompletionsNeeded")
        }
      }

      public var completionCount: Double {
        get {
          return resultMap["completionCount"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "completionCount")
        }
      }

      public var intervalBetweenWindows: Double {
        get {
          return resultMap["intervalBetweenWindows"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "intervalBetweenWindows")
        }
      }

      public var windowLength: Double {
        get {
          return resultMap["windowLength"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "windowLength")
        }
      }

      public var teamId: String {
        get {
          return resultMap["teamId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "teamId")
        }
      }

      public var assignedUser: AssignedUser {
        get {
          return AssignedUser(unsafeResultMap: resultMap["assignedUser"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "assignedUser")
        }
      }

      public var creator: Creator {
        get {
          return Creator(unsafeResultMap: resultMap["creator"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "creator")
        }
      }

      public var status: String {
        get {
          return resultMap["status"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public struct AssignedUser: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserModel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("username", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(userId: String, createdAt: String, username: String, email: String, isActive: Bool) {
          self.init(unsafeResultMap: ["__typename": "UserModel", "userId": userId, "createdAt": createdAt, "username": username, "email": email, "isActive": isActive])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return resultMap["userId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "userId")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var username: String {
          get {
            return resultMap["username"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "username")
          }
        }

        public var email: String {
          get {
            return resultMap["email"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var isActive: Bool {
          get {
            return resultMap["isActive"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isActive")
          }
        }
      }

      public struct Creator: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserModel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("username", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(userId: String, createdAt: String, username: String, email: String, isActive: Bool) {
          self.init(unsafeResultMap: ["__typename": "UserModel", "userId": userId, "createdAt": createdAt, "username": username, "email": email, "isActive": isActive])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return resultMap["userId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "userId")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var username: String {
          get {
            return resultMap["username"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "username")
          }
        }

        public var email: String {
          get {
            return resultMap["email"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var isActive: Bool {
          get {
            return resultMap["isActive"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isActive")
          }
        }
      }
    }
  }
}

public final class GetTeamsByUserIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetTeamsByUserId($userId: String!) {
      getTeamsByUserId(userId: $userId) {
        __typename
        teamId
        createdAt
        teamName
        tasks {
          __typename
          taskId
          createdAt
          taskName
          notes
          startDate
          endDate
          requiredCompletionsNeeded
          completionCount
          intervalBetweenWindows
          windowLength
          teamId
          assignedUser {
            __typename
            userId
            createdAt
            username
            email
            isActive
          }
          creator {
            __typename
            userId
            createdAt
            username
            email
            isActive
          }
          status
        }
        teamMembers {
          __typename
          userId
          createdAt
          username
          email
          isActive
        }
      }
    }
    """

  public let operationName: String = "GetTeamsByUserId"

  public var userId: String

  public init(userId: String) {
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTeamsByUserId", arguments: ["userId": GraphQLVariable("userId")], type: .nonNull(.list(.nonNull(.object(GetTeamsByUserId.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTeamsByUserId: [GetTeamsByUserId]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTeamsByUserId": getTeamsByUserId.map { (value: GetTeamsByUserId) -> ResultMap in value.resultMap }])
    }

    public var getTeamsByUserId: [GetTeamsByUserId] {
      get {
        return (resultMap["getTeamsByUserId"] as! [ResultMap]).map { (value: ResultMap) -> GetTeamsByUserId in GetTeamsByUserId(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetTeamsByUserId) -> ResultMap in value.resultMap }, forKey: "getTeamsByUserId")
      }
    }

    public struct GetTeamsByUserId: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["TeamModel"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("teamId", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("teamName", type: .nonNull(.scalar(String.self))),
          GraphQLField("tasks", type: .nonNull(.list(.nonNull(.object(Task.selections))))),
          GraphQLField("teamMembers", type: .nonNull(.list(.nonNull(.object(TeamMember.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(teamId: String, createdAt: String, teamName: String, tasks: [Task], teamMembers: [TeamMember]) {
        self.init(unsafeResultMap: ["__typename": "TeamModel", "teamId": teamId, "createdAt": createdAt, "teamName": teamName, "tasks": tasks.map { (value: Task) -> ResultMap in value.resultMap }, "teamMembers": teamMembers.map { (value: TeamMember) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var teamId: String {
        get {
          return resultMap["teamId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "teamId")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var teamName: String {
        get {
          return resultMap["teamName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "teamName")
        }
      }

      public var tasks: [Task] {
        get {
          return (resultMap["tasks"] as! [ResultMap]).map { (value: ResultMap) -> Task in Task(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Task) -> ResultMap in value.resultMap }, forKey: "tasks")
        }
      }

      public var teamMembers: [TeamMember] {
        get {
          return (resultMap["teamMembers"] as! [ResultMap]).map { (value: ResultMap) -> TeamMember in TeamMember(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: TeamMember) -> ResultMap in value.resultMap }, forKey: "teamMembers")
        }
      }

      public struct Task: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["TaskModel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("taskId", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("taskName", type: .nonNull(.scalar(String.self))),
            GraphQLField("notes", type: .scalar(String.self)),
            GraphQLField("startDate", type: .nonNull(.scalar(String.self))),
            GraphQLField("endDate", type: .scalar(String.self)),
            GraphQLField("requiredCompletionsNeeded", type: .nonNull(.scalar(Double.self))),
            GraphQLField("completionCount", type: .nonNull(.scalar(Double.self))),
            GraphQLField("intervalBetweenWindows", type: .nonNull(.scalar(Double.self))),
            GraphQLField("windowLength", type: .nonNull(.scalar(Double.self))),
            GraphQLField("teamId", type: .nonNull(.scalar(String.self))),
            GraphQLField("assignedUser", type: .nonNull(.object(AssignedUser.selections))),
            GraphQLField("creator", type: .nonNull(.object(Creator.selections))),
            GraphQLField("status", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(taskId: String, createdAt: String, taskName: String, notes: String? = nil, startDate: String, endDate: String? = nil, requiredCompletionsNeeded: Double, completionCount: Double, intervalBetweenWindows: Double, windowLength: Double, teamId: String, assignedUser: AssignedUser, creator: Creator, status: String) {
          self.init(unsafeResultMap: ["__typename": "TaskModel", "taskId": taskId, "createdAt": createdAt, "taskName": taskName, "notes": notes, "startDate": startDate, "endDate": endDate, "requiredCompletionsNeeded": requiredCompletionsNeeded, "completionCount": completionCount, "intervalBetweenWindows": intervalBetweenWindows, "windowLength": windowLength, "teamId": teamId, "assignedUser": assignedUser.resultMap, "creator": creator.resultMap, "status": status])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var taskId: String {
          get {
            return resultMap["taskId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "taskId")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var taskName: String {
          get {
            return resultMap["taskName"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "taskName")
          }
        }

        public var notes: String? {
          get {
            return resultMap["notes"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "notes")
          }
        }

        public var startDate: String {
          get {
            return resultMap["startDate"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "startDate")
          }
        }

        public var endDate: String? {
          get {
            return resultMap["endDate"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endDate")
          }
        }

        public var requiredCompletionsNeeded: Double {
          get {
            return resultMap["requiredCompletionsNeeded"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "requiredCompletionsNeeded")
          }
        }

        public var completionCount: Double {
          get {
            return resultMap["completionCount"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "completionCount")
          }
        }

        public var intervalBetweenWindows: Double {
          get {
            return resultMap["intervalBetweenWindows"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "intervalBetweenWindows")
          }
        }

        public var windowLength: Double {
          get {
            return resultMap["windowLength"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "windowLength")
          }
        }

        public var teamId: String {
          get {
            return resultMap["teamId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "teamId")
          }
        }

        public var assignedUser: AssignedUser {
          get {
            return AssignedUser(unsafeResultMap: resultMap["assignedUser"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "assignedUser")
          }
        }

        public var creator: Creator {
          get {
            return Creator(unsafeResultMap: resultMap["creator"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "creator")
          }
        }

        public var status: String {
          get {
            return resultMap["status"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "status")
          }
        }

        public struct AssignedUser: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["UserModel"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(String.self))),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("username", type: .nonNull(.scalar(String.self))),
              GraphQLField("email", type: .nonNull(.scalar(String.self))),
              GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(userId: String, createdAt: String, username: String, email: String, isActive: Bool) {
            self.init(unsafeResultMap: ["__typename": "UserModel", "userId": userId, "createdAt": createdAt, "username": username, "email": email, "isActive": isActive])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return resultMap["userId"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "userId")
            }
          }

          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var username: String {
            get {
              return resultMap["username"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "username")
            }
          }

          public var email: String {
            get {
              return resultMap["email"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "email")
            }
          }

          public var isActive: Bool {
            get {
              return resultMap["isActive"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isActive")
            }
          }
        }

        public struct Creator: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["UserModel"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("userId", type: .nonNull(.scalar(String.self))),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("username", type: .nonNull(.scalar(String.self))),
              GraphQLField("email", type: .nonNull(.scalar(String.self))),
              GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(userId: String, createdAt: String, username: String, email: String, isActive: Bool) {
            self.init(unsafeResultMap: ["__typename": "UserModel", "userId": userId, "createdAt": createdAt, "username": username, "email": email, "isActive": isActive])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var userId: String {
            get {
              return resultMap["userId"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "userId")
            }
          }

          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var username: String {
            get {
              return resultMap["username"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "username")
            }
          }

          public var email: String {
            get {
              return resultMap["email"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "email")
            }
          }

          public var isActive: Bool {
            get {
              return resultMap["isActive"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isActive")
            }
          }
        }
      }

      public struct TeamMember: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserModel"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("userId", type: .nonNull(.scalar(String.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("username", type: .nonNull(.scalar(String.self))),
            GraphQLField("email", type: .nonNull(.scalar(String.self))),
            GraphQLField("isActive", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(userId: String, createdAt: String, username: String, email: String, isActive: Bool) {
          self.init(unsafeResultMap: ["__typename": "UserModel", "userId": userId, "createdAt": createdAt, "username": username, "email": email, "isActive": isActive])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var userId: String {
          get {
            return resultMap["userId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "userId")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var username: String {
          get {
            return resultMap["username"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "username")
          }
        }

        public var email: String {
          get {
            return resultMap["email"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var isActive: Bool {
          get {
            return resultMap["isActive"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isActive")
          }
        }
      }
    }
  }
}
