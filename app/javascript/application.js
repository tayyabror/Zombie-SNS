// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails


document.addEventListener('DOMContentLoaded', function() {
  // Chart data
  var percentageData = {
    labels: ['Infected', 'Healthy'],
    datasets: [{
      label: 'Percentage',
      data: [30, 70],
      backgroundColor: ['#FF6384', '#36A2EB'],
      hoverOffset: 4
    }]
  };

  var barData = {
    labels: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
    datasets: [{
      label: 'Infected',
      data: [10, 15, 20, 18, 12],
      backgroundColor: '#FF6384',
      borderWidth: 1
    }, {
      label: 'Healthy',
      data: [30, 25, 20, 22, 28],
      backgroundColor: '#36A2EB',
      borderWidth: 1
    }]
  };

  // Percentage chart
  var percentageChart = new Chart(document.getElementById('percentageChart').getContext('2d'), {
    type: 'doughnut',
    data: percentageData,
    options: {
      responsive: true,
      plugins: {
        legend: {
          position: 'bottom'
        }
      }
    }
  });

  // Bar chart
  var barChart = new Chart(document.getElementById('barChart').getContext('2d'), {
    type: 'bar',
    data: barData,
    options: {
      responsive: true,
      scales: {
        x: {
          grid: {
            display: false
          }
        },
        y: {
          beginAtZero: true,
          ticks: {
            stepSize: 5
          }
        }
      },
      plugins: {
        legend: {
          position: 'bottom'
        }
      }
    }
  });
});
