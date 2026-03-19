# Publishing the Claude Workflow Playbook — Free

The playbook is a **single HTML file** with zero dependencies, no build step, and no framework. It works anywhere that serves static files.

---

## Option 1: GitHub Pages (recommended — 2 minutes)

```bash
# 1. Create a repo
gh repo create claude-workflow-playbook --public
# (or create it manually at github.com/new)

# 2. Clone it and add the file
git clone https://github.com/YOUR_USERNAME/claude-workflow-playbook.git
cd claude-workflow-playbook
cp /path/to/index.html .
cp /path/to/scaffold.sh .

# 3. Push
git add -A
git commit -m "initial: claude workflow playbook"
git push origin main

# 4. Enable GitHub Pages
#    Go to: Settings → Pages → Source → "main" branch → / (root) → Save
#    Your site will be live at: https://YOUR_USERNAME.github.io/claude-workflow-playbook/
```

That's it. Free hosting, free HTTPS, custom domain support if you want it later.

---

## Option 2: Cloudflare Pages (also 2 minutes, faster CDN)

1. Go to https://pages.cloudflare.com
2. Connect your GitHub repo (or drag-and-drop the `index.html` file)
3. Build settings: leave everything blank (no build command needed)
4. Deploy → Live in ~30 seconds

Free tier: unlimited bandwidth, global CDN, custom domain support.

---

## Option 3: Netlify Drop (60 seconds, no account needed for testing)

1. Go to https://app.netlify.com/drop
2. Drag the folder containing `index.html` onto the page
3. Done — you get a random URL instantly

To keep it permanently, create a free Netlify account and claim the site.

---

## Option 4: Vercel (if you already use it)

```bash
npx vercel --prod
```

Free tier covers this easily.

---

## Adding a Custom Domain (optional)

All four options support custom domains for free. If you want something like `playbook.stackre.com`:

1. Add a CNAME record in your DNS pointing to the hosting provider
2. Configure the custom domain in the hosting dashboard
3. HTTPS is automatic on all platforms

---

## Updating the Playbook

Since it's a single HTML file in a git repo, updating is just:

```bash
# Edit index.html
git add index.html
git commit -m "update: added new phase tips"
git push
```

GitHub Pages / Cloudflare / Netlify auto-deploy on push.
