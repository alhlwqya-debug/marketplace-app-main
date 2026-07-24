import re

build_file = 'android/build.gradle'
with open(build_file, 'r') as f:
    content = f.read()

repos_block = """
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        google()
        mavenCentral()
"""

# Replace google() and mavenCentral() with mirrors
new_content = re.sub(r'google\(\)', repos_block, content)
with open(build_file, 'w') as f:
    f.write(new_content)

print("Updated repositories successfully!")
