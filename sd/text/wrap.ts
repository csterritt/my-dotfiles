#!/usr/bin/env -S bun --enable-source-maps
/*
  Reads stdin, tokenizes on whitespace, and writes words wrapped to 80 columns.
  Two or more consecutive newlines in the input mark a paragraph break, which is
  preserved as a single blank line in the output.
*/

const MAX_WIDTH = 95

const wrapWords = (words: string[], maxWidth = MAX_WIDTH): string[] => {
  const lines: string[] = []
  let line = ''

  for (const w of words) {
    if (line.length === 0) {
      // Start a new line with the word, even if it exceeds maxWidth (no hyphenation)
      line = w
    } else if (line.length + 1 + w.length <= maxWidth) {
      line += ' ' + w
    } else {
      lines.push(line)
      line = w
    }
  }

  if (line.length > 0) lines.push(line)
  return lines
}

const processInput = (input: string): string => {
  // Normalize newlines
  const text = input.replace(/\r\n?/g, '\n')

  const outLines: string[] = []
  let paragraphWords: string[] = []
  let emptyStreak = 0

  const flushParagraph = () => {
    if (paragraphWords.length > 0) {
      outLines.push(...wrapWords(paragraphWords, MAX_WIDTH))
      paragraphWords = []
    }
  }

  const lines = text.split('\n')
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]
    if (line.trim() === '') {
      // An empty split line corresponds to two consecutive newlines in the input
      if (paragraphWords.length > 0) {
        // End of a paragraph: flush accumulated words and emit one blank line
        flushParagraph()
        outLines.push('')
        emptyStreak = 1
      } else {
        // Already between paragraphs or at start: preserve additional blank lines
        outLines.push('')
        emptyStreak += 1
      }
    } else {
      // Non-empty line
      emptyStreak = 0
      // Break the line on whitespace and accumulate words
      const words = line.trim().split(/\s+/).filter(Boolean)
      paragraphWords.push(...words)
    }
  }

  // Flush any remaining words as the last paragraph
  flushParagraph()

  // Join with newlines and ensure a single trailing newline
  const out = outLines.join('\n')
  return out.endsWith('\n') ? out : out + '\n'
}

const main = () => {
  const chunks: string[] = []
  if (process.stdin.isTTY) {
    // No stdin; nothing to do
    return
  }
  process.stdin.setEncoding('utf8')
  process.stdin.on('data', (chunk) => chunks.push(String(chunk)))
  process.stdin.on('end', () => {
    const input = chunks.join('')
    const output = processInput(input)
    process.stdout.write(output)
  })
}

main()
