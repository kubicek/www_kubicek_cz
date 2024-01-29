---
icon: fas fa-tags
order: 9
layout: page
title: Notes
no_toc: true
---

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  Moje užitečné poznámky, digital garden, knowledge base ... 🌱
</p>

<strong>Naposledy aktualizováno:</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>
