#!/bin/bash



login(){
echo "----------------------------------------"
echo "Attempting to log in to GitHub..."
echo "----------------------------------------"
gh auth login
}

status(){
gh auth status
}

create_repo(){
echo "----------------------------------------"
echo "Attempting to create a new repository..."
echo "----------------------------------------"

 git config --global user.name "Ashu Gupta"
    git config --global user.email "ashugt73@gmail.com"


 git config --global --add safe.directory "$(pwd)"
read -p "Enter the name for the repository: " repo

if [ -z "$repo" ]; then
        echo "Repository name cannot be empty."
        return
fi


read -p "Enter the description for the repo/project: " desc

echo "Select repo visibility"
echo "1. Public"
echo "2. Private"
read -p "Enter your choice (public/private): " choice

if [ "$choice" == "1" ]; then
	visibility="--public"
elif [ "$choice" == "2" ]; then
	visibility="--private"
else
	echo "Invalid choice. Redirecting to Public."
	visibility="--public"
fi

echo
echo "Creating repository '$repo' ..."
gh repo create "$repo" $visibility --description "$desc"

echo "----------------------------------------"
echo "Repo created successfully" "$repo"
echo "Description" "$desc"
echo "Visibility: $visibility"
echo "----------------------------------------" 

username=$(gh api user --jq '.login')

url="https://github.com/$username/$repo.git"

#Initialize and connect to repo

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "$url"
git push -u origin main


}

push(){

echo "----------------------------------------"
echo "Attempting to push all the work into your repository..."
echo "----------------------------------------"





}

echo "Main Menu"
echo "1. Login into the github"
echo "2. Check the status of your github Account"
echo "3. Create a repository"
echo "4. Add all your work on your github Account"


read -p "Enter the choice: " choice



case "$choice" in 
1) echo "You selected: Login into the github"
	login
;;

2) echo "You selected: Check you account status"
	status
;;

3) echo "You selected: Create a repository"
	create_repo
;;

4) echo "You selected: Add all work onto github"
	push
;;

*)

echo "Invalid choice"
;;
esac
