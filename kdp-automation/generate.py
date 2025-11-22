#!/usr/bin/env python3
"""
KDP Automation - Japanese Book Manuscript Generator
Generates a 5,000-word Japanese book manuscript using OpenAI API
"""

import os
import sys
import argparse
from pathlib import Path
from dotenv import load_dotenv
from openai import OpenAI


def load_api_key():
    """Load OpenAI API key from .env file"""
    load_dotenv()
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY not found in .env file")
    return api_key


def sanitize_filename(title):
    """Sanitize title for use as filename"""
    # Remove invalid characters for Windows filenames
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        title = title.replace(char, '_')
    # Remove leading/trailing spaces and dots
    title = title.strip(' .')
    return title


def generate_manuscript(client, title, outline):
    """Generate 5,000-word Japanese book manuscript using OpenAI API"""
    print(f"Generating manuscript for: {title}")
    print(f"Outline: {outline}")
    print("This may take a few minutes...")
    
    prompt = f"""以下のタイトルとアウトラインに基づいて、日本語で5,000語（約10,000文字）の本の原稿を生成してください。

タイトル: {title}

アウトライン:
{outline}

要件:
- 日本語で書く
- 約5,000語（約10,000文字）の長さ
- 明確な構造と流れのある内容
- プロフェッショナルな文体
- アウトラインに従う
- 完全な原稿として完成させる

原稿を生成してください："""

    try:
        print("Calling OpenAI API...")
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {
                    "role": "system",
                    "content": "あなたは経験豊富な日本語の本の著者です。与えられたタイトルとアウトラインに基づいて、高品質な日本語の本の原稿を生成します。"
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            temperature=0.7,
            max_tokens=4000  # GPT-4 can handle longer outputs
        )
        
        manuscript = response.choices[0].message.content
        print(f"✓ Manuscript generated successfully!")
        print(f"  Length: {len(manuscript)} characters")
        
        return manuscript
        
    except Exception as e:
        raise Exception(f"Error generating manuscript: {str(e)}")


def save_manuscript(title, manuscript):
    """Save manuscript to file"""
    # Sanitize title for filename
    safe_title = sanitize_filename(title)
    
    # Create output directory if it doesn't exist
    output_dir = Path(r"C:\KDP\manuscripts\japanese")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Create file path
    output_file = output_dir / f"{safe_title}.txt"
    
    try:
        # Save manuscript
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(manuscript)
        
        print(f"✓ Manuscript saved to: {output_file}")
        return output_file
        
    except Exception as e:
        raise Exception(f"Error saving manuscript: {str(e)}")


def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Generate a 5,000-word Japanese book manuscript using OpenAI API"
    )
    parser.add_argument(
        "title",
        type=str,
        help="Title of the book"
    )
    parser.add_argument(
        "outline",
        type=str,
        help="Outline of the book content"
    )
    
    args = parser.parse_args()
    
    try:
        # Display progress
        print("=" * 60)
        print("KDP Japanese Book Manuscript Generator")
        print("=" * 60)
        
        # Step 1: Load API key
        print("\n[1/3] Loading API key from .env file...")
        api_key = load_api_key()
        print("✓ API key loaded successfully")
        
        # Step 2: Initialize OpenAI client
        print("\n[2/3] Initializing OpenAI client...")
        client = OpenAI(api_key=api_key)
        print("✓ OpenAI client initialized")
        
        # Step 3: Generate manuscript
        print("\n[3/3] Generating manuscript...")
        manuscript = generate_manuscript(client, args.title, args.outline)
        
        # Step 4: Save manuscript
        print("\n[Saving] Saving manuscript to file...")
        output_file = save_manuscript(args.title, manuscript)
        
        # Success message
        print("\n" + "=" * 60)
        print("✓ SUCCESS: Manuscript generated and saved!")
        print(f"  Output: {output_file}")
        print("=" * 60)
        
    except KeyboardInterrupt:
        print("\n\n✗ Operation cancelled by user")
        sys.exit(1)
    except ValueError as e:
        print(f"\n✗ ERROR: {str(e)}")
        sys.exit(1)
    except Exception as e:
        print(f"\n✗ ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()

