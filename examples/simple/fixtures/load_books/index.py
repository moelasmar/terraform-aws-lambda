import json
import boto3
import os
import languages_lib
import csv
from io import StringIO


def lambda_handler(event, context):
    print("load books function start")

    bucket_name = os.environ['books_input_bucket']
    object_key = os.environ['books_input']
    books_table = os.environ['books_table_id'] 
    s3_client = boto3.client('s3')
    dynamodb = boto3.client('dynamodb')
    
    books_object = s3_client.get_object(Bucket=bucket_name, Key=object_key)
    books_object_body = books_object['Body']
    books_csv_string = books_object_body.read().decode('utf-8')
    
    f = StringIO(books_csv_string)
    reader = csv.reader(f, delimiter=',')
    for row in reader:
        print(f"adding book {row} to books_table")
        language = languages_lib.get_language_by_short_code(row[2])
        dynamodb.put_item(TableName=books_table, Item={
            'id':{'S':row[0]},
            'title':{'S':row[1]},
            'language':{'S':language.get('language_name')}
        })

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Books Input get loaded",
        }),
    }
