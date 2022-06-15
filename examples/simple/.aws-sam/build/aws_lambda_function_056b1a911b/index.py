import json
import python_layer_version_dependency

def lambda_handler(event, context):
    print("Hello world from app2!")

    depend = python_layer_version_dependency.get_dependency()

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"hello world from app2. Dependency value {depend}",
        }),
    }
