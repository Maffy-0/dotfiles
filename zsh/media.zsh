# ~/.zsh/media.zsh

# MP4 を 720p HEVC に変換
resizemp4() {
    if [ $# -eq 1 ]; then
        input="$1"
        tmp="${input%.mp4}_tmp.mp4"

        echo "The input file will be resized and overwritten."
        read "answer?Do you want to continue? [y/N] "
        case "$answer" in
            [Yy]*);;
            *) echo "Operation cancelled."; return 1;;
        esac

        ffmpeg -i "$input" \
          -vf scale=1280:720 -c:v hevc_videotoolbox -b:v 2500k \
          -tag:v hvc1 -pix_fmt yuv420p -movflags +faststart -an \
          "$tmp"

        if [ $? -eq 0 ]; then
            mv "$tmp" "$input"
            echo "Successfully overwritten."
        else
            echo "An error occurred during processing. The temporary file has been kept."
            return 1
        fi

    elif [ $# -eq 2 ]; then
        ffmpeg -i "$1" \
          -vf scale=1280:720 -c:v hevc_videotoolbox -b:v 2500k \
          -tag:v hvc1 -pix_fmt yuv420p -movflags +faststart -an \
          "$2"
    else
        echo "Usage: resizemp4 input.mp4 [output.mp4]"
        return 1
    fi
}



# 画像の長辺 or 縦サイズ基準縮小（デフォルト 720）
resizeimg() {
    if [ $# -lt 1 ]; then
        echo "Usage: resizeimg <input_file> [-s size]"
        echo "Example: resizeimg image.jpg -s 480"
        return 1
    fi
    local input="$1"
    shift
    local size=720
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--size)
                size="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done
    local filename=$(basename -- "$input")
    local extension="${filename##*.}"
    local name="${filename%.*}"
    local output="${name}_${size}p.${extension}"
    ffmpeg -y -i "$input" -vf "scale=-1:${size}:force_original_aspect_ratio=decrease" "$output"
}

# m4a → mp3
convertm4a() {
  if [ -z "$1" ]; then
    echo "使い方: convertm4a input.m4a [output.mp3]"
    return 1
  fi
  local input="$1"
  local output="${2:-${input%.m4a}.mp3}"
  ffmpeg -i "$input" -codec:a libmp3lame -b:a 192k "$output"
  echo "変換完了: $output"
}

# 画像 → PDF（ImageMagick）
converttopdf() {
    if [ $# -ne 2 ]; then
        echo "使い方: converttopdf input_image output.pdf"
        return 1
    fi
    local input="$1"
    local output="$2"
    if [ ! -f "$input" ]; then
        echo "入力ファイルが存在しません: $input"
        return 1
    fi
    convert "$input" "$output"
}

