jQuery(document).ready(function () {
    if (jQuery("#template").length) {
        var e = document.querySelector("#template");
        e.id = "";
        var t = e.parentNode.innerHTML;
        e.parentNode.removeChild(e);
        var o = new Dropzone(document.body, {
            url: "upload.ashx",
            thumbnailWidth: 80,
            thumbnailHeight: 80,
            parallelUploads: 20,
            previewTemplate: t,
            acceptedFiles: "image/*",
            autoQueue: !1,
            previewsContainer: "#previews",
            clickable: ".fileinput-button"
        });
        o.on("success",function (e, data) {
            $(".name", e.previewElement).text(data)
        }),
        o.on("queuecomplete", function () {
            $.post("synchroAttribute.ashx");
        }),
        o.on("addedfile",function (e) {
            e.previewElement.querySelector(".start").onclick = function () {
                o.enqueueFile(e)
            }
        }),
        o.on("totaluploadprogress",function (e) {
            document.querySelector("#total-progress .progress-bar").style.width = e + "%"
        }),
        o.on("sending", function (e, xhr, formData) {            
            formData.append("title", $("#title").val());
            formData.append("category", $("#category").val());
            document.querySelector("#total-progress").style.opacity = "1",
            e.previewElement.querySelector(".start").setAttribute("disabled", "disabled")
        }),
        o.on("queuecomplete",function () {
            document.querySelector("#total-progress").style.opacity = "0"
        }),
        document.querySelector("#actions .start").onclick = function () {
            o.enqueueFiles(o.getFilesWithStatus(Dropzone.ADDED))
        },
        document.querySelector("#actions .cancel").onclick = function () {
            o.removeAllFiles(!0)
        }
    }
});