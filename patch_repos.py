import re

def patch_file(filepath):
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        
        mirror_block = """
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        google()
        mavenCentral()
        """
        
        if 'google()' in content and 'aliyun' not in content:
            new_content = content.replace('google()', mirror_block)
            with open(filepath, 'w') as f:
                f.write(new_content)
            print(f"Updated {filepath}")
    except Exception as e:
        print(f"Skipped {filepath}: {e}")

patch_file('android/settings.gradle')
patch_file('android/build.gradle')
