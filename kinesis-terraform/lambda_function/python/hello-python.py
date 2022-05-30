def lambda_handler(event, context):
   message = 'Hellooo {} !'.format(event['key1'])
   return {
       'message' : message
   }
