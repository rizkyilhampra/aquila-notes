---
<%*
   let title = tp.file.title;
   let timestamp = tp.date.now('X');
   let suffix = null;
   if (title.startsWith('Untitled')) {
      title = await tp.system.prompt('Enter title');
	  if(title != null) {
	    suffix = title.replace(/ /g, '-')
                  .replace(/[^A-Za-z0-9-]/g, '')
                  .toLowerCase();
	  } else {
		suffix = '';
		for (let i = 0; i < 4; i++) {
		  suffix += String.fromCharCode(65 + Math.floor(Math.random() * 26));
	    }
	  }
	  
      await tp.file.rename(`${timestamp}-${suffix}`);
   }
-%>
id: <% tp.date.now('X') %>-<%* tR += `${suffix}` %>
alias: <%* tR += `${title}` %>
tags: []
---
# <%* tR += `${title ?? ''}` %>