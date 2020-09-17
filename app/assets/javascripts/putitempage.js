$(function(){

  //DataTransferオブジェクトで、データを格納する箱を作る
  let dataBox = new DataTransfer();

  let file_field = document.querySelector('input[type=file]')

  $('.putitems-image').change(function(){
    // let files = $('input[type=file]').prop('files')[0];

    $.each(this.files, function(i, file){
      let fileReader = new FileReader();
      
      dataBox.items.add(file)

      file_field.files = dataBox.files

      let num = $('.item-image').length + 1 + i
      fileReader.readAsDataURL(file);

      if (num == 10){
        $('.putitems__image--input').css('display','none')
      }

    
    

    fileReader.onloadend = function(){
      let src = fileReader.result
      let html = `<div class='item-image' data-image="${file.name}">
                    <div class=' item-image__content'>
                      <div class='item-image__content--icon'>
                        <img src=${src} width="114" height="130" margin-top="16" class='image-icon' >
                      </div>
                    </div>
                    <div class='item-image__operetion'>
                      <div class='item-image__operetion--delete'>削除</div>
                    </div>
                  </div>`
      $('.putitems__image--input').before(html);
    };
    $('.putitems__image--input').add('class', `item-num-${num}`)
  });
});

  $(document).on("click", '.item-image__operetion--delete', function(){
    //プレビュー要素を取得
    let target_image = $(this).parent().parent()
    //プレビューを削除
    target_image.remove();
    //inputタグに入ったファイルを削除
    file_field.val("")
  })






  

  // 子カテゴリーの導入
  function build_childSelect(){
    let child_select =`
              <div class="child-collection">
                <select name="product[category_id]" class="child_category_id">
                  <option value="">選択してください</option>
                </select>
              </div>
              `
      return child_select;
  }
  function build_Option(children){
    let option_html = `
                      <option value=${children.id}>${children.name}</option>
                      `
    return option_html;
  }


  $("#product_category_id").change(function(){
    let parentValue = $("#product_category_id").val();

    if (parentValue.length != 0){
      $.ajax({
        url: '/products/search',
        type: "GET",
        data: {
          parent_id: parentValue
        },
        dataType: 'json'
        })

      .done(function(data){
        $(".child_category_id").remove();
        $(".grandchild_category_id").remove();

        let child_select = build_childSelect
        $(".category-collection").append(child_select);
        data.forEach(function(d){
          let option_html = build_Option(d)
          $(".child_category_id").append(option_html);
        })
      })
      .fail(function(){
        alert("通信エラーです")
      });
    }
  });




  // 孫カテゴリーの導入
  function build_grandchildSelect(){
    let grandchild_select =`
                          <select name="product[category_id]" class="grandchild_category_id">
                            <option value="">選択してください</option>
                          </select>
                          `
      return grandchild_select;
  }
  function build_Option(children){
    let option_html = `
                      <option value=${children.id}>${children.name}</option>
                      `
    return option_html;
  }

  $(document).on("change", ".child_category_id", function(){
    let childValue = $(".child_category_id").val();

    if (childValue.length != 0){
      $.ajax({
        url: '/products/search',
        type: "GET",
        data: {
          child_id: childValue
        },
        dataType: 'json'
        })

      .done(function(data){
        $(".grandchild_category_id").remove();

        let grandchild_select = build_grandchildSelect
        $(".category-collection").append(grandchild_select);

        data.forEach(function(grand_d){
          let option_html = build_Option(grand_d);
          $(".grandchild_category_id").append(option_html);
        })
      })
      .fail(function(){
        alert("通信エラーです")
      });
    }
  });



});