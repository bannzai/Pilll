import json
import os
import re
import openai

# OpenAI API key (replace with your actual key)
openai.api_key = os.getenv("OPENAI_API_KEY")

os.chdir("../")


# Function to translate text using OpenAI's API with Function Calling
def translate_english_value(text):
    print(f"Translating: {text}")
    response = openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": """
                    Flutterで作られたピル管理アプリ・Pilllの翻訳作業を手伝ってください。次に渡すアプリ上で使われている文言を適切に英訳してください
            """,
            },
            {
                "role": "user",
                "content": f"Translate the following text into English from ja .arb value: '{text}'",
            },
        ],
        functions=[
            {
                "name": "translate",
                "description": """
                    Flutterで作られたピル管理アプリ・Pilllの翻訳作業を手伝ってください。次に渡すアプリ上で使われている文言を適切に英訳してください
                """,
                "parameters": {
                    "type": "object",
                    "properties": {
                        "translated": {
                            "type": "string",
                            "description": "The translated text.",
                        }
                    },
                    "required": ["translated"],
                },
            }
        ],
        function_call={"name": "translate"},
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


# Main function to convert JSON to .arb
ja_arb = {}
en_arb = {}


def convert_json_to_arb(input_path):
    ja_arb_json_data = load_json(input_path)
    # i = 0
    for ja_key in ja_arb_json_data:
        if ja_key == "" or ja_key[0] == "@":
            continue

        ja_value = ja_arb_json_data[ja_key]

        # Map to number prefix to with `L_`.
        english_value = translate_english_value(ja_value)

        # Add to the .arb data
        en_arb[ja_key] = english_value


# Paths to input and output files
ja_arb_path = "lib/l10n/app_ja.arb"
en_arb_path = "lib/l10n/app_en.arb"

# Execute the conversion
if __name__ == "__main__":
    convert_json_to_arb(ja_arb_path)
    # Save to .arb file
    save_arb(en_arb_path, en_arb)
