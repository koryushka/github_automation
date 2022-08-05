
# gh search prs --review approved --repo tourlane/spider --state open --author "app/dependabot"
# l=$(gh pr list --author "app/dependabot" | awk '{print $1}')
l=$(gh search prs --review approved --repo tourlane/$(basename $(pwd)) --state open --author "app/dependabot"| awk '{print $2}')
if [ ${!l[@]} -eq 0 ]; then
    echo "No PRs to approve"
fi
for i in $l; do
    echo "Checkout PR: $l"
    gh pr checkout $i
    echo "Checked out"
    echo "Rebasing on top of staging...."
    git checkout staging
    git pull origin staging
    git checkout -
    git rebase staging
    echo "Rebased"
    echo "Pushing..."
    git push origin HEAD --force-with-lease
    echo "Pushed"
done