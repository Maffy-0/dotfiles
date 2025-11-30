# ~/.zsh/media.zsh

# MP4 を HEVC に変換（ビットレート・解像度指定に対応）
resizemp4() {
    if [ $# -lt 1 ] || [ $# -gt 4 ]; then
        echo "Usage: resizemp4 input.mp4 [bitrate] [height] [output.mp4]"
        echo "  bitrate の例: 800k, 1000k, 1500k （省略時 1000k）"
        echo "  height の例: 480, 720, 1080       （省略時 720）"
        return 1
    fi

    input="$1"
    bitrate="${2:-1000k}"
    height="${3:-720}"

    # width はアスペクト比維持で自動計算する（-2 を指定）
    scale_opt="scale=-2:${height}"

    if [ $# -le 3 ]; then
        # 上書きモード
        tmp="${input%.mp4}_tmp.mp4"

        echo "The input file will be resized and overwritten."
        read "answer?Do you want to continue? [y/N] "
        case "$answer" in
            [Yy]*);;
            *) echo "Operation cancelled."; return 1;;
        esac

        ffmpeg -i "$input" \
          -vf "$scale_opt" \
          -c:v hevc_videotoolbox -b:v "$bitrate" \
          -tag:v hvc1 -pix_fmt yuv420p -movflags +faststart -an \
          "$tmp"

        if [ $? -eq 0 ]; then
            mv "$tmp" "$input"
            echo "Successfully overwritten."
        else
            echo "An error occurred during processing. The temporary file has been kept."
            return 1
        fi

    else
        # 別ファイル出力モード
        output="$4"

        ffmpeg -i "$input" \
          -vf "$scale_opt" \
          -c:v hevc_videotoolbox -b:v "$bitrate" \
          -tag:v hvc1 -pix_fmt yuv420p -movflags +faststart -an \
          "$output"
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

