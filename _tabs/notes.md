---
icon: fas fa-tags
order: 9
layout: page
title: Notes
no_toc: true
---

Moje užitečné poznámky, digital garden, knowledge base ... 🌱

<strong>Naposledy aktualizováno:</strong>

<ul>
  {% assign recent_notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in recent_notes limit: 5 %}
    <li>
      {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
    </li>
  {% endfor %}
</ul>

{% comment %}
<p>Here are all the notes in this garden, along with their links, visualized as a graph.</p>

{% include notes_graph.html %}

{% endcomment %}