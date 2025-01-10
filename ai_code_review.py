import os
import subprocess
import requests

# Lấy danh sách các file thay đổi từ Pull Request
changed_files = subprocess.check_output(
    ["git", "diff", "--name-only", "origin/main...HEAD"]
).decode().strip().split("\n")

review_comments = []

# Duyệt qua từng file để AI đưa ra nhận xét
for file in changed_files:
    if file.endswith(".py"):  # Giới hạn chỉ review file Python
        with open(file, 'r') as f:
            code_content = f.read()

        # Gọi Ollama AI model
        response = subprocess.run(
            ["ollama", "run", "llama2", f"Review this code: {code_content}"],
            capture_output=True, text=True
        )

        review = response.stdout.strip()
        review_comments.append(f"**File:** {file}\n{review}")

# Đăng nhận xét lên Pull Request
pr_number = os.getenv("GITHUB_REF").split("/")[-1]
repo = os.getenv("GITHUB_REPOSITORY")
token = os.getenv("TOKEN")

for comment in review_comments:
    requests.post(
        f"https://api.github.com/repos/{repo}/issues/{pr_number}/comments",
        headers={"Authorization": f"token {token}"},
        json={"body": comment}
    )
