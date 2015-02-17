# list branches by the their most recent commit date
alias old-branches='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r'

# what ever your current directory under the repo is,
# cdd will bring you to the repo root
alias cdd='cd $(git rev-parse --show-cdup)'

# show your commits across all branches in the last 7 days
function recent-commits() {
  git log \
  --pretty=format:"%ad -- %an -- %d -- %B" \
  --date=relative \
  --branches \
  --since=7.days.ago \
  --author="$1"
}
