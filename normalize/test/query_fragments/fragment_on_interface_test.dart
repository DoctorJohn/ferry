import 'package:test/test.dart';
import 'package:gql/language.dart';

import 'package:normalize/normalize.dart';

void main() {
  group('Fragment On Interface', () {
    /*
    interface ActorInterface {
      id: ID!
      avatarUrl: String!
    }
    type UserType implements ActorInterface {
      id: ID!
      avatarUrl: String!
      name: String!
    }
    */
    final query = parseString('''
      query TestQuery {
        users {
          ... ActorInfo
        }
      }
      fragment ActorInfo on ActorInterface {
        __typename
        id
        avatarUrl
      }
    ''');
    final responseData = {
      "users": [
        {
          "__typename": "UserType",
          "id": "1",
          "avatarUrl": "http://example.com/avatar.png",
        },
      ],
    };
    final normalizedMap = {
      "Query": {
        "users": [
          {
            "\$ref": "UserType:1",
          },
        ],
      },
      "UserType:1": {
        "__typename": "UserType",
        "id": "1",
        "avatarUrl": "http://example.com/avatar.png",
      },
    };
    test("Produces correct normalized object", () {
      final normalizedResult = {};
      normalize(
        writer: (dataID, value) => normalizedResult[dataID] = value,
        query: query,
        data: responseData,
      );
      expect(
        normalizedResult,
        equals(normalizedMap),
      );
    });
  });
}
