import "../stylesheets/datatables";

$(document).on('turbolinks:load',function(){
  var table1 = $('.datatable table').DataTable({
    language: {
      search: `<span class="search-label">Search</span>`,
      searchPlaceholder: "Search"
    },
    dom:
		"<'row align-items-center mb-2'<'col-12 col-xl-3 text-center text-xl-left mb-2 mb-xl-0'l><'col-12 col-xl-9 text-center text-xl-right'f>>" +
		"<'row'<'col-12'tr>>" +
		"<'row align-items-center mt-2'<'col-12 col-md-7'i><'col-12 col-md-5'p>>",
    responsive: {
      details: {
        display: $.fn.dataTable.Responsive.display.childRowImmediate
      }
    },
      buttons: {
        buttons: [ 'copy', 'csv', 'excel', 'pdf', 'print' ],
        dom: {
          button: {
            className: 'btn btn-outline-primary'
          }
        }
      }
  });

  table1.buttons().container()
      .prependTo( '.dataTables_wrapper .col-xl-9:eq(0)' );

  var table2 = $('.no-datatable table').DataTable({
    dom:
    "<'row'<'col-12'><'col-12'>>" +
    "<'row'<'col-12'tr>>" +
    "<'row'<'col-12'><'col-12'>>",
    responsive: {
      details: {
        display: $.fn.dataTable.Responsive.display.childRowImmediate
      }
    },
    bSort: false
  });
  document.addEventListener("turbolinks:before-cache", function() {
    if (table1 !== null) {
      table1.destroy();
      table1 = null;
    }
    if (table2 !== null) {
      table2.destroy();
      table2 = null;
    }
  });
});

pdfMake.fonts = {
  // download default Roboto font from cdnjs.com
  Roboto: {
    normal: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Regular.ttf',
    bold: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Medium.ttf',
    italics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-Italic.ttf',
    bolditalics: 'https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.66/fonts/Roboto/Roboto-MediumItalic.ttf'
  },
}