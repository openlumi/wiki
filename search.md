---
layout: default
---

<!-- HTML elements for search -->
<div class="search-wrapper">
        <svg viewBox="0 0 24 24">
          <path d="M9.5,3A6.5,6.5 0 0,1 16,9.5C16,11.11 15.41,12.59 14.44,13.73L14.71,14H15.5L20.5,19L19,20.5L14,15.5V14.71L13.73,14.44C12.59,15.41 11.11,16 9.5,16A6.5,6.5 0 0,1 3,9.5A6.5,6.5 0 0,1 9.5,3M9.5,5C7,5 5,7 5,9.5C5,12 7,14 9.5,14C12,14 14,12 14,9.5C14,7 12,5 9.5,5Z"></path>
        </svg>
        <input type="text" class="search full-width" id="search-input" >
  </div>
<div class="search-results" id="results-container"></div>



<script src="https://unpkg.com/simple-jekyll-search@latest/dest/simple-jekyll-search.min.js"></script>
<script>
var sjs = SimpleJekyllSearch({
  searchInput: document.getElementById('search-input'),
  resultsContainer: document.getElementById('results-container'),
  json: '/wiki/search.json',
  noResultsText: 'Нет результатов',
  debounceTime: 200,
  limit: 30
})
</script>
