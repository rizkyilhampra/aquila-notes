---
<%*
   let title = tp.file.title;
   let id = tp.date.now('YYYYMMDD');
   if (title.startsWith('Untitled')) {
      title = await tp.system.prompt('Enter title');
      await tp.file.rename(`${id}-${title}`);
   }
-%>
id: <% tp.date.now('YYYYMMDD') %>-<%* tR += `${title}` %>
alias: <%* tR += `${title}` %>
tags: []
---
# <%* tR += `${title}` %>

<% tp.file.cursor() %>