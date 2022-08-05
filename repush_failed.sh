
#!/bin/bash
l=$(gh search prs --repo tourlane/$(basename $(pwd)) --state open --review approved --author "app/dependabot"  | awk '{print $2}') # --review approved --author "app/dependabot" --checks pending --author "app/dependabot" 
# l=$(gh search prs --repo tourlane/slack_reminder --state open  | awk '{print $2}') # --review approved --author "app/dependabot" --checks pending --author "app/dependabot" 
# if [ ${l[@]} -eq 0 ]; then
#     echo "No failed PRs!"
# fi

for i in $l; do
    status=$(gh pr view $i --json 'statusCheckRollup' | jq '.statusCheckRollup | {status: .[].conclusion}.status')
    mergeStateStatus=$(gh pr view $i --json mergeStateStatus |  jq '.mergeStateStatus')
    
    if [ "$status" = '"SUCCESS"' ] && [ "$mergeStateStatus" = '"CLEAN"' ]; then
      echo "CAN BE MERGED!: $i"
      echo "Merging remotely.."
      gh pr merge $i --auto --squash
    else
      echo "CAN NOT BE MERGED: $i !!!!"
      echo "Status: $status"
      echo "mergeStateStatus: $mergeStateStatus"
    fi
    # if [ $status = '"SUCCESS"' ] && [ $mergeStateStatus='"CLEAN"' ]; then
    #   echo "CAN BE MERGED"
    # #   echo "Merging remotely.."
    # #   gh pr merge $i --auto --squash
    # fi
    # echo $status  | jq '.statusCheckRollup | .conclusion'
    # '[.[] | {message: .commit.message, name: .commit.committer.name, parents: [.parents[].html_url]}]'
    # status=$(gh pr checks $i | awk '{print $3}')
    # if [ $status = "pass" ]; then
        # echo "Status: $status"
        # gh pr merge $i --auto --squash

    # fi
    # gh pr checkout $l
    # echo "Checked out"
    # echo "Merging...."
    # git commit --amend --no-edit
    # echo "Merged"
    # echo "Pushing..."
    # git push origin HEAD --force-with-lease
    # echo "Pushed"
    # echo "Merging remotely"
    # gh pr merge $l --auto --squash
done