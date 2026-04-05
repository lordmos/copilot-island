//
//  MarkdownMessageView.swift
//  CopilotIsland
//
//  Renders assistant messages as rich Markdown using apple/swift-markdown.
//  Handles: paragraphs, headings, code blocks, lists, blockquotes, inline formatting.
//

import SwiftUI
import Markdown

// MARK: - Markdown Message View

/// Full-featured Markdown renderer for assistant messages.
struct MarkdownMessageView: View {
    let text: String

    var body: some View {
        let doc = Document(parsing: text)
        let blocks = Array(doc.children.enumerated())
        if blocks.isEmpty {
            SwiftUI.Text(text)
                .font(.system(size: 12))
                .foregroundColor(CopilotTheme.textPrimary)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(blocks, id: \.offset) { _, block in
                    MarkdownBlockView(block: block)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Block Renderer

private struct MarkdownBlockView: View {
    let block: any Markup

    var body: some View {
        Group {
            if let para = block as? Paragraph {
                InlineText(nodes: Array(para.children))
                    .font(.system(size: 12))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)

            } else if let heading = block as? Heading {
                InlineText(nodes: Array(heading.children))
                    .font(headingFont(heading.level))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, heading.level <= 2 ? 4 : 1)

            } else if let code = block as? CodeBlock {
                CodeBlockView(code: code.code, language: code.language)

            } else if let list = block as? UnorderedList {
                BulletListView(items: Array(list.children.compactMap { $0 as? ListItem }))

            } else if let list = block as? OrderedList {
                NumberedListView(items: Array(list.children.compactMap { $0 as? ListItem }))

            } else if let quote = block as? BlockQuote {
                BlockQuoteView(children: Array(quote.children))

            } else if block is ThematicBreak {
                Divider()
                    .background(CopilotTheme.border)
                    .padding(.vertical, 2)

            } else {
                // Fallback: render plain text
                let raw = block.format().trimmingCharacters(in: .whitespacesAndNewlines)
                if !raw.isEmpty {
                    SwiftUI.Text(raw)
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.textSecondary)
                        .textSelection(.enabled)
                }
            }
        }
    }

    private func headingFont(_ level: Int) -> Font {
        switch level {
        case 1: return .system(size: 15, weight: .bold)
        case 2: return .system(size: 13, weight: .semibold)
        case 3: return .system(size: 12, weight: .semibold)
        default: return .system(size: 12, weight: .medium)
        }
    }
}

// MARK: - Inline Text (AttributedString)

private struct InlineText: View {
    let nodes: [any Markup]

    var body: some View {
        SwiftUI.Text(buildAttributedString())
    }

    private func buildAttributedString() -> AttributedString {
        var result = AttributedString()
        for node in nodes {
            result += renderInline(node)
        }
        return result
    }

    private func renderInline(_ node: any Markup) -> AttributedString {
        switch node {
        case let t as Markdown.Text:
            return AttributedString(t.string)

        case let code as InlineCode:
            var str = AttributedString(code.code)
            str.font = .system(size: 11, design: .monospaced)
            return str

        case let strong as Strong:
            var str = AttributedString()
            for child in strong.children { str += renderInline(child) }
            str.font = .system(size: 12, weight: .bold)
            return str

        case let em as Emphasis:
            var str = AttributedString()
            for child in em.children { str += renderInline(child) }
            str.font = .system(size: 12).italic()
            return str

        case let link as Markdown.Link:
            var str = AttributedString()
            for child in link.children { str += renderInline(child) }
            if let dest = link.destination, let url = URL(string: dest) {
                str.link = url
            }
            str.foregroundColor = .init(CopilotTheme.sagePrimary)
            return str

        case let strikethrough as Strikethrough:
            var str = AttributedString()
            for child in strikethrough.children { str += renderInline(child) }
            str.strikethroughStyle = .single
            return str

        case is SoftBreak:
            return AttributedString(" ")

        case is LineBreak:
            return AttributedString("\n")

        default:
            var str = AttributedString()
            for child in node.children { str += renderInline(child) }
            return str
        }
    }
}

// MARK: - List Views

private struct BulletListView: View {
    let items: [ListItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(items.indices, id: \.self) { idx in
                HStack(alignment: .top, spacing: 6) {
                    SwiftUI.Text("•")
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.sagePrimary)
                        .frame(width: 10, alignment: .center)
                    ListItemContent(item: items[idx])
                }
            }
        }
    }
}

private struct NumberedListView: View {
    let items: [ListItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(items.indices, id: \.self) { idx in
                HStack(alignment: .top, spacing: 6) {
                    SwiftUI.Text("\(idx + 1).")
                        .font(.system(size: 12))
                        .foregroundColor(CopilotTheme.sagePrimary)
                        .frame(width: 20, alignment: .trailing)
                    ListItemContent(item: items[idx])
                }
            }
        }
    }
}

private struct ListItemContent: View {
    let item: ListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(item.children.enumerated()), id: \.offset) { _, child in
                MarkdownBlockView(block: child)
            }
        }
    }
}

// MARK: - Blockquote

private struct BlockQuoteView: View {
    let children: [any Markup]

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(CopilotTheme.sagePrimary.opacity(0.5))
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(children.enumerated()), id: \.offset) { _, child in
                    MarkdownBlockView(block: child)
                }
            }
            .padding(.leading, 10)
        }
    }
}

// MARK: - Code Block View

struct CodeBlockView: View {
    let code: String
    let language: String?
    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header bar
            HStack {
                SwiftUI.Text(language ?? "")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(CopilotTheme.textTertiary)
                Spacer()
                Button(action: copyCode) {
                    HStack(spacing: 3) {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 9))
                        SwiftUI.Text(copied ? "Copied" : "Copy")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(copied ? CopilotTheme.successGreen : CopilotTheme.textTertiary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.35))

            // Code content
            ScrollView(.horizontal, showsIndicators: false) {
                SwiftUI.Text(code.trimmingCharacters(in: .newlines))
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(CopilotTheme.textPrimary)
                    .textSelection(.enabled)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.black.opacity(0.2))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(CopilotTheme.border, lineWidth: 0.5)
        )
    }

    private func copyCode() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        withAnimation { copied = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { copied = false }
        }
    }
}
