import json
import os
import re
import openai

# OpenAI API key (replace with your actual key)
openai.api_key = os.getenv("OPENAI_API_KEY")

os.chdir('../')

# Function to translate text using OpenAI's API with Function Calling
def translate_text_with_openai(text):
    print(f"Translating: {text}")
    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "You are a translator that only returns translations in a requested language."},
            {"role": "user", "content": f"Translate the following text into English: '{text}'"}
        ],
        functions=[
            {
                "name": "translate",
                "description": "Translate text into English",
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
    return json.loads(response.choices[0].message.function_call.arguments)[
        "translated"
    ]


# Load JSON data from app_localizations.json
def load_json(filepath):
    with open(filepath, "r", encoding="utf-8") as file:
        return json.load(file)

# Save data to an .arb file
def save_arb(filepath, data):
    with open(filepath, "w", encoding="utf-8") as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Replace variable patterns (e.g., $VAL or ${VAL}) with {VAL}
def replace_variable_patterns(text):
    original = text
    text = re.sub(r'\$(\w+)', r'{\1}', text)  # Replace $VAL with {VAL}
    text = re.sub(r'\${(\w+)}', r'{\1}', text)  # Replace ${VAL} with {VAL}
    print(f"Replaced variable patterns: {original} → {text}")
    return text

# Main function to convert JSON to .arb
def convert_json_to_arb(input_path, output_path):
    print("Converting JSON to .arb...")
    json_data = load_json(input_path)
    arb_data = {}

    for key in json_data:
        # Replace variable patterns
        replaced_key = replace_variable_patterns(key)
        
        # Translate the key using OpenAI's API
        translated_key = translate_text_with_openai(replaced_key)
        
        # Add to the .arb data
        arb_data[translated_key] = translated_key

    # Save to .arb file
    save_arb(output_path, arb_data)

# Paths to input and output files
input_json_path = "lib/l10n/app_localizations.json"
output_arb_path = "lib/l10n/app_en.arb"

# Execute the conversion
if __name__ == "__main__":
    convert_json_to_arb(input_json_path, output_arb_path)
