import cairosvg, os, json

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

sizes = [(16,1),(16,2),(32,1),(32,2),(128,1),(128,2),(256,1),(256,2),(512,1),(512,2)]
path1 = "M7.998 15.035c-4.562 0-7.873-2.914-7.998-3.749V9.338c.085-.628.677-1.686 1.588-2.065.013-.07.024-.143.036-.218.029-.183.06-.384.126-.612-.201-.508-.254-1.084-.254-1.656 0-.87.128-1.769.693-2.484.579-.733 1.494-1.124 2.724-1.261 1.206-.134 2.262.034 2.944.765.05.053.096.108.139.165.044-.057.094-.112.143-.165.682-.731 1.738-.899 2.944-.765 1.23.137 2.145.528 2.724 1.261.566.715.693 1.614.693 2.484 0 .572-.053 1.148-.254 1.656.066.228.098.429.126.612.012.076.024.148.037.218.924.385 1.522 1.471 1.591 2.095v1.872c0 .766-3.351 3.795-8.002 3.795Zm0-1.485c2.28 0 4.584-1.11 5.002-1.433V7.862l-.023-.116c-.49.21-1.075.291-1.727.291-1.146 0-2.059-.327-2.71-.991A3.222 3.222 0 0 1 8 6.303a3.24 3.24 0 0 1-.544.743c-.65.664-1.563.991-2.71.991-.652 0-1.236-.081-1.727-.291l-.023.116v4.255c.419.323 2.722 1.433 5.002 1.433ZM6.762 2.83c-.193-.206-.637-.413-1.682-.297-1.019.113-1.479.404-1.713.7-.247.312-.369.789-.369 1.554 0 .793.129 1.171.308 1.371.162.181.519.379 1.442.379.853 0 1.339-.235 1.638-.54.315-.322.527-.827.617-1.553.117-.935-.037-1.395-.241-1.614Zm4.155-.297c-1.044-.116-1.488.091-1.681.297-.204.219-.359.679-.242 1.614.091.726.303 1.231.618 1.553.299.305.784.54 1.638.54.922 0 1.28-.198 1.442-.379.179-.2.308-.578.308-1.371 0-.765-.123-1.242-.37-1.554-.233-.296-.693-.587-1.713-.7Z"
path2 = "M6.25 9.037a.75.75 0 0 1 .75.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 .75-.75Zm4.25.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 1.5 0Z"

# ── Design parameters ─────────────────────────────────────────────────────────
r = 230           # squircle background corner radius
sw, sh = 808, 600  # screen width, height
sx, sy = 108, 210  # screen top-left
srx = 28          # screen corner radius

nw, nh = 430, 145  # notch dimensions
nbcr = 55          # bottom corner radius only (top edge is flat/straight)
nx = 512 - nw // 2   # = 297 (horizontally centred)
ny = sy             # notch top flush with screen top edge, cuts downward
cam_cy = ny + nh // 2  # = 282 (centre of notch)

notch_bottom = ny + nh    # = 355
screen_bottom = sy + sh   # = 810
logo_center_y = (notch_bottom + screen_bottom) / 2  # ≈ 582
logo_size = 370
logo_scale = logo_size / 16   # ≈ 23.125
logo_x = 512 - logo_size / 2  # = 327
logo_y = logo_center_y - logo_size / 2  # ≈ 397

# Notch path: flat top, rounded bottom-left and bottom-right corners
# M top-left → top-right → straight down → arc bottom-right → bottom-left → arc bottom-left → close
notch_path = (
    f"M {nx},{ny} "
    f"H {nx+nw} "
    f"V {ny+nh-nbcr} "
    f"Q {nx+nw},{ny+nh} {nx+nw-nbcr},{ny+nh} "
    f"H {nx+nbcr} "
    f"Q {nx},{ny+nh} {nx},{ny+nh-nbcr} "
    f"Z"
)

# ── Colours ───────────────────────────────────────────────────────────────────
# Background: subtle diagonal gradient from deep forest-teal to near-black
BG_LIGHT   = "#132018"   # top-left highlight
BG_DARK    = "#080D0B"   # bottom-right deep
SCREEN_TOP = "#6BBA94"   # sagePrimary  (app theme)
SCREEN_BOT = "#2F7356"   # deeper green for richer gradient
NOTCH_COL  = BG_DARK     # notch matches bg dark for depth
LOGO_COL   = "#0A1510"   # deep forest = "carved into screen" effect

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <!-- Background: diagonal dark forest gradient — userSpaceOnUse so notch can reuse it seamlessly -->
    <linearGradient id="bggrad" x1="154" y1="0" x2="870" y2="1024" gradientUnits="userSpaceOnUse">
      <stop offset="0%"   stop-color="{BG_LIGHT}"/>
      <stop offset="100%" stop-color="{BG_DARK}"/>
    </linearGradient>
    <!-- Screen: rich sage-to-deep-green gradient -->
    <linearGradient id="screenbg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%"   stop-color="{SCREEN_TOP}"/>
      <stop offset="100%" stop-color="{SCREEN_BOT}"/>
    </linearGradient>
  </defs>

  <!-- Squircle background with diagonal forest gradient -->
  <rect width="1024" height="1024" rx="{r}" ry="{r}" fill="url(#bggrad)"/>

  <!-- Sage green screen -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="url(#screenbg)"/>

  <!-- Screen border — subtle white inner glow -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="none"
        stroke="rgba(255,255,255,0.14)" stroke-width="2"/>

  <!-- Notch: flat top flush with screen, rounded bottom corners — real MacBook notch shape -->
  <path d="{notch_path}" fill="#000000"/>

  <!-- Camera LED dot inside notch -->
  <circle cx="512" cy="{cam_cy}" r="7" fill="{SCREEN_TOP}" opacity="0.6"/>
  <circle cx="512" cy="{cam_cy}" r="3" fill="#B8F5D4"/>

  <!-- Copilot logo in deep-forest colour — "carved into screen" effect -->
  <g transform="translate({logo_x:.1f},{logo_y:.1f}) scale({logo_scale:.3f})" fill="{LOGO_COL}" opacity="0.90">
    <path d="{path1}"/>
    <path d="{path2}"/>
  </g>
</svg>'''

icon_dir = "CopilotIsland/Assets.xcassets/AppIcon.appiconset"
with open(f"{icon_dir}/AppIcon_source.svg","w") as f: f.write(svg)
entries = []
for (pt, sc) in sizes:
    px = pt * sc
    fn = f"AppIcon_{pt}x{pt}@{sc}x.png"
    # background_color=None ensures corners outside the squircle are transparent (no white border)
    cairosvg.svg2png(
        url=f"{icon_dir}/AppIcon_source.svg",
        write_to=f"{icon_dir}/{fn}",
        output_width=px,
        output_height=px,
        background_color=None,
    )
    entries.append((pt, sc, fn))
    print(f"  {fn}")

images = [{"filename": fn, "idiom": "mac", "scale": f"{sc}x", "size": f"{pt}x{pt}"}
          for (pt, sc, fn) in entries]
with open(f"{icon_dir}/Contents.json","w") as f:
    json.dump({"images": images, "info": {"author": "xcode", "version": 1}}, f, indent=2)
print("Done!")
