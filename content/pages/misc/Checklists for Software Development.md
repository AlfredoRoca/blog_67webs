Description: Checklists for Software Development
Date: /9/2017
Categories: 
Summary: Before submitting a pull request, when you are reviewing a PR & before deploying, ask yourself some questions.
Keywords: 
Flags: draft

#Checklists for Software Development

**Before submitting a pull request**

The submitter should always ask themselves the following questions:

- Have I looked at every line of the diff between your branch and master?
- Is there anything in this patch that is not related to the overall change?
- Have I structures the commits to make the reviewer's job easy?
- Have I tested the code locally?
- Should QA look at this before I submit it for a review?
- Does the PR explain how to verify that the feature is working?

**When you are reviewing a PR**

The reviwer should always ask themselves the following questions:

- Do I understand the goal of this change?
- Have I looked at every line of the diff between the branch and master?
- Have I used the code locally?
- Should this go through additional QA?
- Are there sufficient unit and functional tests?
- How will we know if this change "works"?

**Before deploying**

The submitter and the reviewer should always take a minute and ask each other the following:

- What are we worried about going wrong?
- Is there anything different about this change in production vs in dev/test?
- Is now an optimal time to deploy this change?
- Is it possible or desirable to roll this out to a subset of our users?
- What specific steps will each of us take when the deploy finishes to verify that the changes work?
- If something goes wrong, what will we do? Is this safe to revert and re-deploy?

Source: RailsConf 2017

