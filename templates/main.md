---
<%*
   let title = tp.file.title;
   let id = tp.date.now('X');
   if (title.startsWith('Untitled')) {
      title = await tp.system.prompt('Enter title');
	  title = title
      await tp.file.rename(`${id}-${title}`);
   }
-%>
id: <% tp.date.now('X') %>-<%* tR += `${title}` %>
alias: <%* tR += `${title}` %>
tags: []
---
# <%* tR += `${title}` %>