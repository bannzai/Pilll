import json
import os
import re
import openai

# OpenAI API key (replace with your actual key)
openai.api_key = os.getenv("OPENAI_API_KEY")

os.chdir('../')

# Function to translate text using OpenAI's API with Function Calling
def translate_key(text):
    print(f"Translating: {text}")
    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": """
                    Please assist with the translation work for the pill management app, Pilll, created with Flutter. 
                    Generate appropriate .arb keys for the provided Japanese text

                    This means the following rules apply. Remember that this will be used as a key in the Flutter project source code:
                    - Start with English letters
                    - Only use the underscore (_) symbol; replace any other symbols, such as periods (.), with underscores
                    - No spaces allowed
             """},
            {"role": "user", "content": f"Translate the following text to .arb file key: '{text}'"}
        ],
        functions=[
            {
                "name": "translate",
                "description": """
                    Please assist with the translation work for the pill management app, Pilll, created with Flutter. 
                    Generate appropriate .arb keys for the provided Japanese text

                    This means the following rules apply. Remember that this will be used as a key in the Flutter project source code:
                    - Start with English letters
                    - Only use the underscore (_) symbol; replace any other symbols, such as periods (.), with underscores
                    - No spaces allowed
                """,
                "parameters": {
                    "type": "object",
                    "properties": {
                        "translated": {"type": "string", "description": "The translated text."}
                    },
                    "required": ["translated"]
                }
            }
        ],
        function_call={"name": "translate"}
    )
    translated = json.loads(response.choices[0].message.function_call.arguments)[
        "translated"
    ]
    print(f"Translated: {translated}")
    return translated

def translate_english_value(text):
    print(f"Translating: {text}")
    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": """
                Please assist with the translation work for the pill management app, Pilll, 
                created with Flutter. Provide an appropriate English translation for the given Japanese text. 
                This translation will be used as a value in the .arb file, 
                so please keep variable placeholders such as \{name\} intact

                This means the following rules apply. Remember that this will be used as a value of .arb file in the Flutter project source code:
                - Only use the underscore (_) symbol; replace any other symbols, such as periods (.), with underscores. Allow space.
            """},
            {"role": "user", "content": f"Translate the following text into English for .arb value: '{text}'"}
        ],
        functions=[
            {
                "name": "translate",
                "description": """
                    Please assist with the translation work for the pill management app, Pilll, 
                    created with Flutter. Provide an appropriate English translation for the given Japanese text. 
                    This translation will be used as a value in the .arb file, 
                    so please keep variable placeholders such as \{name\} intact

                    This means the following rules apply. Remember that this will be used as a value of .arb file in the Flutter project source code:
                    - Only use the underscore (_) symbol; replace any other symbols, such as periods (.), with underscores. Allow space.
                """,
                "parameters": {
                    "type": "object",
                    "properties": {
                        "translated": {"type": "string", "description": "The translated text."}
                    },
                    "required": ["translated"]
                }
            }
        ],
        function_call={"name": "translate"}
    )
    translated = json.loads(response.choices[0].message.function_call.arguments)[
        "translated"
    ]
    print(f"Translated: {translated}")
    return translated
# Load JSON data from app_localizations.json
def load_json(filepath):
    with open(filepath, "r", encoding="utf-8") as file:
        return json.load(file)

# Save data to an .arb file
def save_arb(filepath, data):
    with open(filepath, "w", encoding="utf-8") as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Replace variable patterns (e.g., $VAL or ${VAL}) with {VAL}
def replace_variable_patterns(text) -> str:
    original = text
    text = re.sub(r'\$(\w+)', r'{\1}', text)  # Replace $VAL with {VAL}
    text = re.sub(r'\${(\w+)}', r'{\1}', text)  # Replace ${VAL} with {VAL}
    print(f"Replaced variable patterns: {original} -> {text}")
    return text;

# Main function to convert JSON to .arb
ja_arb = {}
en_arb = {}
def convert_json_to_arb(input_path):
    print("Converting JSON to .arb...")
    json_data = load_json(input_path)
    # i = 0
    for key in json_data:
        # i += 1
        # if i > 30:
        #     return
        # arb の value (en_value)については Dart $ → {} の変換で良い
        # key にはそれ以外の制約もあるので後から value から変換する
        # Replace variable patterns
        replaced_key = replace_variable_patterns(key)

        # Translate the key using OpenAI's API
        arb_key = translate_key(replaced_key)
        # Map to number prefix to with `L_`.
        arb_key = f"l_{arb_key}" if arb_key[0].isdigit() else arb_key
        english_value = translate_english_value(replaced_key)
        
        # Add to the .arb data
        ja_arb[arb_key] = replaced_key
        en_arb[arb_key] = english_value


# Paths to input and output files
input_json_path = "lib/l10n/app_localizations.json"
en_arb_path = "lib/l10n/app_en.arb"
ja_arb_path = "lib/l10n/app_ja.arb"

# Execute the conversion
if __name__ == "__main__":
    convert_json_to_arb(input_json_path)
    # Save to .arb file
    save_arb(en_arb_path, en_arb)
    save_arb(ja_arb_path, ja_arb)