# Vizualizing Indian Development and Natural Resource Data
Comp 150 Vizualization final class project With William Butt, Nate Tenczar, Sean Hirata, and Alden Keefe Sampson.

This visualization is primarily implemented in Processing (java).

## Git Workflow
We will probably use only one branch (the master branch) for simplicity. By default you are on the master branch so you don't need to worry about branches.

#### Initial Setup
If you haven't used git with github before, do
```
git config --global user.name "Your Name Here"
git config --global user.email "your_email@example.com"
```
This email should be the one you used to sign up with github.

Now, just clone the repository into a directory of your choosing. This will create a folder `india-dev-viz` containing the project.
```
git clone git@github.com:aldenks/india-dev-viz.git
```

#### Adding New Files
```
git add <filename or directory> # makes git aware of all files/directories of files provided, but does not commit any changes.
  # eg. 'git add .' will add all the files in the current subtree
git commit -m "Your helpful commit message. eg. Added README"
```

#### Regular Workflow
make some changes to files, then commit them:
```
git commit -am "Commit message. eg. Refactored dependency checking, better documentation"
```
The `-a` flag is important, it says commit changes to files that git is aware of. If you don't add it nothing will be commited.

When you're ready to share one or more commits with everyone else, first commit all your local changes, then
```
git pull # make sure you have the lastest changes from the server
git push # push your commits to the server
```

When you pull, you may have some "merge conflicts." This means you and someone else both made changes to the same part of the same file and git can't figure out how to automatically merge them.
Git will tell you which files have conflicts. Open these files and edit them to be how you want them. They will have lines of `<<<<` and `>>>>` separating the edits from you and someone else. Save the files, then commit them and push.

#### Other Useful Commands
```
git status # lets you know what files are modified, commited, etc.
git log    # shows you a list of recent commits
git diff   # shows you what has changed since your last commit. Good to look at before commiting
```
