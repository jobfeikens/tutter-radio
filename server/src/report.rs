use async_std::fs::File;
use async_std::path::Path;
use futures::AsyncWriteExt;

pub async fn report_song(artist: &str, title: &str, message: &str) -> anyhow::Result<()> {
    let dir = std::env::current_dir()?.join(Path::new("reports"));

    let mut song_path = dir.join(create_name(artist, title, None));

    let mut attempt = 0;
    while song_path.exists() {
        attempt += 1;
        song_path = dir.join(create_name(artist, title, Some(attempt)));
    }
    let mut file = File::create(song_path).await?;
    file.write_all(message.as_bytes()).await?;
    file.close().await?;
    Ok(())
}

fn create_name(artist: &str, title: &str, attempt: Option<usize>) -> String {
    let mut name = format!("{} - {}", artist, title);
    if let Some(attempt) = attempt {
        name += &format!(" ({})", attempt);
    }
    name + ".txt"
}