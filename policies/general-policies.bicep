

// {
//   properties: {
//     displayName: 'Allowed locations'
//     description: 'This policy enables you to restrict the locations your organization can specify when deploying resources.'
//     mode: 'Indexed'
//     metadata: {
//       version: '1.0.0'
//       category: 'Locations'
//     }
//     parameters: {
//       allowedLocations: {
//         type: 'array'
//         metadata: {
//           description: 'The list of locations that can be specified when deploying resources'
//           strongType: 'location'
//           displayName: 'Allowed locations'
//         }
//         defaultValue: [
//           'westus2'
//         ]
//       }
//     }
//     policyRule: {
//       if: {
//         not: {
//           field: 'location'
//           in: allowedLocations
//         }
//       }
//       then: {
//         effect: 'deny'
//       }
//     }
//   }
// }
