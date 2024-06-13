# News

{% for item in site.data.news %}
  <div class="news-item">
    <span class="news-date">[{{ item.date }}]</span> <span class="news-text">{{ item.text | markdownify }}</span>
  </div>
{% endfor %}

<br />

[//]: # (<p class="section-break"></p>)