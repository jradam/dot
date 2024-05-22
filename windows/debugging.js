// Outline all elements. Identify on hover with pink border. On click, hide element.
function debugLayout() {
  const colors = ['red', 'green', 'blue', 'orange', 'purple']

  document.querySelectorAll('*').forEach((element, index) => {
    const color = colors[index % colors.length]

    const { style } = element

    style.outline = `1px solid ${color}`

    element.addEventListener('mouseover', (event) => {
      event.stopPropagation()
      style.outline = `3px solid hotpink`
      style.cursor = 'pointer'
    })

    element.addEventListener('mouseout', (event) => {
      event.stopPropagation()
      style.outline = `1px solid ${color}`
      style.cursor = ''
    })

    element.addEventListener('click', (event) => {
      event.stopPropagation()
      event.preventDefault()
      style.display = 'none'
    })
  })
}

// As a bookmarklet
javascript:(function(){const%20colors=['red','green','blue','orange','purple'];document.querySelectorAll('*').forEach((e,i)=>{const%20c=colors[i%colors.length],s=e.style;s.outline=`1px%20solid%20${c}`;e.addEventListener('mouseover',t=>{t.stopPropagation();s.outline='3px%20solid%20hotpink';s.cursor='pointer'});e.addEventListener('mouseout',t=>{t.stopPropagation();s.outline=`1px%20solid%20${c}`;s.cursor=''});e.addEventListener('click',t=>{t.stopPropagation();t.preventDefault();s.display='none'})})})();
