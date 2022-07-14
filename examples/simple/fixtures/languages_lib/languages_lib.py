import pycountry
from countryinfo import CountryInfo


def get_country_language(country_name):
    country = CountryInfo(country_name)
    languages = []
    for language_short_code in country.languages():
        languages.append(get_language_by_short_code(language_short_code))
    return languages


def get_language_by_short_code(short_code):
    language = pycountry.languages.get(alpha_2=short_code)
    return {
        "language_name": language.name,
        "language_short_code": language.alpha_2,
        "language_long_code" : language.alpha_3, 
    } 
