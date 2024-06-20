$(document).ready(function() {
    var servicesTable = $('#servicesTable').DataTable();
    var intéressésTable = $('#intéressésTable').DataTable();
    var utilisateursTable = $('#utilisateursTable').DataTable();

    // Filtrer par Date de Visite
    $('#filterDate').on('change', function() {
        servicesTable.column(6).search(this.value).draw();
    });

    // Filtrer par Type de Service
    $('#filterService').on('keyup', function() {
        servicesTable.column(2).search(this.value).draw();
    });

    // Filtrer par Lieu de Débitation
    $('#filterLieu').on('keyup', function() {
        servicesTable.column(3).search(this.value).draw();
    });

    // Filtrer par Statut des Services
    $('#filterStatut').on('keyup', function() {
        servicesTable.column(7).search(this.value).draw();
    });
});

$(document).ready(function(){
    $('#keyword').on('input', function(){
        var keyword = $(this).val();
        if (keyword.length >= 3) {
            $.ajax({
                url: '/search',
                method: 'POST',
                data: { keyword: keyword },
                success: function(data){
                    var resultsHtml = '<ul>';
                    data.forEach(function(result){
                        resultsHtml += '<li>' + result + '</li>';
                    });
                    resultsHtml += '</ul>';
                    $('#results').html(resultsHtml);
                }
            });
        } else {
            $('#results').empty();
        }
    });
});