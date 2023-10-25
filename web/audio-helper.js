function getDurationOfAudioById(id) {
    var audio = document.getElementById(id);
    return audio.duration;
}

function playAudioById(id) {
    var audio = document.getElementById(id);
    audio.play();
}

function pauseAudioById(id) {
    var audio = document.getElementById(id);
    audio.pause();
}