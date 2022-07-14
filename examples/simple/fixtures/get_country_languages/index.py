import json
import languages_lib

def lambda_handler(event, context):
    print("get country languages function start")
    country_name = event.get("country_name") if event else None
    if not country_name:
       print("error, country name is not provided") 
       return {
            "statusCode": 500,
            "errorMessage": "country name is mandatory"
       }
    
    print(f"Get Country Languages for Country {country_name}")

    country_languages = languages_lib.get_country_language(country_name)
    print("get country languages function Done")
    print(f"Country Languages {country_languages}")
    return {
        "statusCode": 200,
        "body": json.dumps(country_languages),
    }
