window.addEventListener("message", function(event) {
    var v = event.data
    switch (v.action) {
        case 'openUI': 
            $('.container').fadeIn(200)
           // const pictureURL = `https://nui-img/${v.foto}/${v.foto}`;
            $('.person-container').append(`
                <div class="person" style="background-image: url('https://nui-img/${v.img}/${v.img}');background-position:center;background-repeat: no-repeat;">
                    <p class="nombrepj">${v.name}</p>
                    <img class="mugshot" src="https://nui-img/${v.img}/${v.img}" alt="">
                    <button id=${v.pid} class="btn-1 revive"> <i class="fa-solid fa-user-doctor"></i> Revive</button>
                </div>
            `)

            $(`.btn-1`).click(function(){
                //console.log(this.id)
                $.post('https://Roda_Revive/revive', JSON.stringify({
                    src : this.id
                }));
                CloseAll()
            })
        break;
    }
});

$(document).keyup((e) => {
    
    if (e.key === "Escape") { 
            CloseAll()
    }
});

function CloseAll() {
    $.post('https://Roda_Revive/exit', JSON.stringify({}));
    $('.person').remove()
    $('.container').fadeOut(200)
}
