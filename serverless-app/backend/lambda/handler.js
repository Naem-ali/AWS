// Lambda handler function
module.exports.createItem = async (event) => {
    const AWS = require('aws-sdk');
    const dynamoDB = new AWS.DynamoDB.DocumentClient();
    const { itemName } = JSON.parse(event.body);
  
    const params = {
      TableName: 'ItemsTable',
      Item: {
        id: new Date().toISOString(),
        name: itemName,
      },
    };
  
    try {
      await dynamoDB.put(params).promise();
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Item created successfully!' }),
      };
    } catch (error) {
      return {
        statusCode: 500,
        body: JSON.stringify({ error: 'Failed to create item' }),
      };
    }
  };
  