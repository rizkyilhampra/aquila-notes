---
<%*
   let title = tp.file.title;
   let timestamp = tp.date.now('X');
   let suffix = null;
   if (title.startsWith('Untitled')) {
      title = await tp.system.prompt('Enter title');
      if (title != null && title !== '') {
        suffix = title.replace(/ /g, '-')
                      .replace(/[^A-Za-z0-9-]/g, '')
                      .toLowerCase();
      } else {
        title = 'Untitled';
        suffix = '';
        for (let i = 0; i < 4; i++) {
          suffix += String.fromCharCode(65 + Math.floor(Math.random() * 26));
        }
      }
      await tp.file.rename(`${timestamp}-${suffix}`);
   } else {
      suffix = title.replace(/ /g, '-')
                    .replace(/[^A-Za-z0-9-]/g, '')
                    .toLowerCase();
   }
-%>
id: <%* tR += `${timestamp}-${suffix}` %>
aliases:
- <%* tR += `${title}` %>
tags: []
publish: false
created: <% tp.date.now("YYYY-MM-DD HH:mm") %>
modified: <% tp.date.now("YYYY-MM-DD HH:mm") %>
---
# <%* tR += `${title}` %>
