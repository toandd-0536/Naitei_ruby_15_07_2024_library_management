document.addEventListener('turbo:load', function () {
  var ctx = document.getElementById('myPieChart');

  // Extract the category data from the data attribute
  var categoryData = JSON.parse(ctx.getAttribute('data-category-data'));

  // Proceed with creating the chart if parsing was successfu
  var labels = categoryData.map(item => item.name);
  var data = categoryData.map(item => item.count);

  var colors = ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b']; // Extend this as needed

  var myPieChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: labels,
      datasets: [{
        data: data,
        backgroundColor: colors,
        hoverBackgroundColor: colors.map(function (color) {
          return shadeColor(color, -10); // Slightly darker on hover
        }),
        hoverBorderColor: 'rgba(234, 236, 244, 1)',
      }],
    },
    options: {
      maintainAspectRatio: false,
      tooltips: {
        backgroundColor: 'rgb(255,255,255)',
        bodyFontColor: '#858796',
        borderColor: '#dddfeb',
        borderWidth: 1,
        xPadding: 15,
        yPadding: 15,
        displayColors: false,
        caretPadding: 10,
      },
      legend: {
        display: false // We'll create our own legend
      },
      cutoutPercentage: 80,
    },
  });

  // Generate custom legend
  var legendContainer = document.getElementById('chart-legend');
  categoryData.forEach(function (category, index) {
    var legendItem = document.createElement('span');
    legendItem.classList.add('mr-2');
    legendItem.innerHTML = `<i class='fas fa-circle' style='color: ${colors[index]};'></i> ${category.name}`;
    legendContainer.appendChild(legendItem);
  });
});

function shadeColor(color, percent) {
  var num = parseInt(color.slice(1), 16),
      amt = Math.round(2.55 * percent),
      R = (num >> 16) + amt,
      G = (num >> 8 & 0x00FF) + amt,
      B = (num & 0x0000FF) + amt;
  return '#' + (0x1000000 + (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 + (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 + (B < 255 ? B < 1 ? 0 : B : 255)).toString(16).slice(1).toUpperCase();
}
