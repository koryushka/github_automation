
# gh search prs --review approved --repo tourlane/spider --state open --author "app/dependabot"
# l=$(gh pr list --author "app/dependabot" | awk '{print $1}')
l=$(gh search prs --review required --repo tourlane/$(basename $(pwd)) --state open --author "app/dependabot"| awk '{print $2}')
if [ ${!l[@]} -eq 0 ]; then
    echo "No PRs to approve"
fi
for i in $l; do
    echo "Checkout PR: $l"
    gh pr checkout $i
    echo "Checked out"
    echo "Merging...."
    git commit --amend --no-edit
    echo "Merged"
    echo "Pushing..."
    git push origin HEAD --force-with-lease
    echo "Pushed"
    echo "Approving..."
    gh pr review $i --approve
    echo "Approved"
done