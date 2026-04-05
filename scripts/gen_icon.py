import cairosvg, os, json

os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

sizes = [(16,1),(16,2),(32,1),(32,2),(128,1),(128,2),(256,1),(256,2),(512,1),(512,2)]
path1 = "M7.998 15.035c-4.562 0-7.873-2.914-7.998-3.749V9.338c.085-.628.677-1.686 1.588-2.065.013-.07.024-.143.036-.218.029-.183.06-.384.126-.612-.201-.508-.254-1.084-.254-1.656 0-.87.128-1.769.693-2.484.579-.733 1.494-1.124 2.724-1.261 1.206-.134 2.262.034 2.944.765.05.053.096.108.139.165.044-.057.094-.112.143-.165.682-.731 1.738-.899 2.944-.765 1.23.137 2.145.528 2.724 1.261.566.715.693 1.614.693 2.484 0 .572-.053 1.148-.254 1.656.066.228.098.429.126.612.012.076.024.148.037.218.924.385 1.522 1.471 1.591 2.095v1.872c0 .766-3.351 3.795-8.002 3.795Zm0-1.485c2.28 0 4.584-1.11 5.002-1.433V7.862l-.023-.116c-.49.21-1.075.291-1.727.291-1.146 0-2.059-.327-2.71-.991A3.222 3.222 0 0 1 8 6.303a3.24 3.24 0 0 1-.544.743c-.65.664-1.563.991-2.71.991-.652 0-1.236-.081-1.727-.291l-.023.116v4.255c.419.323 2.722 1.433 5.002 1.433ZM6.762 2.83c-.193-.206-.637-.413-1.682-.297-1.019.113-1.479.404-1.713.7-.247.312-.369.789-.369 1.554 0 .793.129 1.171.308 1.371.162.181.519.379 1.442.379.853 0 1.339-.235 1.638-.54.315-.322.527-.827.617-1.553.117-.935-.037-1.395-.241-1.614Zm4.155-.297c-1.044-.116-1.488.091-1.681.297-.204.219-.359.679-.242 1.614.091.726.303 1.231.618 1.553.299.305.784.54 1.638.54.922 0 1.28-.198 1.442-.379.179-.2.308-.578.308-1.371 0-.765-.123-1.242-.37-1.554-.233-.296-.693-.587-1.713-.7Z"
path2 = "M6.25 9.037a.75.75 0 0 1 .75.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 .75-.75Zm4.25.75v1.501a.75.75 0 0 1-1.5 0V9.787a.75.75 0 0 1 1.5 0Z"

# Design: Dark squircle background + sage green screen with notch cutout + dark Copilot logo
r = 230          # squircle background corner radius
sw, sh = 808, 600  # screen width, height
sx, sy = 108, 210  # screen top-left
srx = 24         # screen corner radius
nw, nh = 380, 110 # notch pill — tall & wide to convey "notch app" concept
nrx = nh // 2    # = 55 (full pill)
nx = 512 - nw // 2   # = 322 (notch left)
ny = sy - nh // 2    # = 155 (notch top, centered on screen top edge)
cam_cy = ny + nh // 2  # = 210 (notch center = screen top edge)
# Logo centered on usable screen area (below notch bottom)
notch_bottom = ny + nh    # = 265
screen_bottom = sy + sh   # = 810
logo_center_y = (notch_bottom + screen_bottom) / 2  # = 537.5
logo_size = 370
logo_scale = logo_size / 16   # ≈ 23.125
logo_x = 512 - logo_size / 2  # = 327
logo_y = logo_center_y - logo_size / 2  # = 352.5

# App theme colors (from CopilotTheme.swift)
BG_COLOR    = "#0D1412"   # background: Color(r:0.05,g:0.08,b:0.07)
SCREEN_TOP  = "#6BBA94"   # sagePrimary: Color(r:0.42,g:0.73,b:0.58)
SCREEN_BOT  = "#388569"   # sageDeep:   Color(r:0.22,g:0.52,b:0.41)

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <linearGradient id="screenbg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="{SCREEN_TOP}"/>
      <stop offset="100%" stop-color="{SCREEN_BOT}"/>
    </linearGradient>
  </defs>

  <!-- App-theme dark green-black squircle background -->
  <rect width="1024" height="1024" rx="{r}" ry="{r}" fill="{BG_COLOR}"/>

  <!-- Sage green screen (sagePrimary → sageDeep gradient) -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="url(#screenbg)"/>

  <!-- Screen border — subtle white ring -->
  <rect x="{sx}" y="{sy}" width="{sw}" height="{sh}" rx="{srx}" fill="none"
        stroke="rgba(255,255,255,0.18)" stroke-width="2"/>

  <!-- Notch pill — same color as background, creates cutout illusion -->
  <rect x="{nx}" y="{ny}" width="{nw}" height="{nh}" rx="{nrx}" fill="{BG_COLOR}"/>

  <!-- Green camera LED dot inside notch -->
  <circle cx="512" cy="{cam_cy}" r="7" fill="{SCREEN_TOP}" opacity="0.7"/>
  <circle cx="512" cy="{cam_cy}" r="3" fill="#A8F0CC"/>

  <!-- White Copilot logo centered on screen -->
  <g transform="translate({logo_x:.1f},{logo_y:.1f}) scale({logo_scale:.3f})" fill="white" opacity="0.92">
    <path d="{path1}"/>
    <path d="{path2}"/>
  </g>
</svg>'''
icon_dir = "CopilotIsland/Assets.xcassets/AppIcon.appiconset"
with open(f"{icon_dir}/AppIcon_source.svg","w") as f: f.write(svg)
entries = []
for (sp,sx) in sizes:
    px = sp*sx; fn = f"AppIcon_{sp}x{sp}@{sx}x.png"
    cairosvg.svg2png(url=f"{icon_dir}/AppIcon_source.svg", write_to=f"{icon_dir}/{fn}", output_width=px, output_height=px)
    entries.append((sp,sx,fn)); print(f"  {fn}")
images=[{"filename":fn,"idiom":"mac","scale":f"{sx}x","size":f"{sp}x{sp}"} for (sp,sx,fn) in entries]
with open(f"{icon_dir}/Contents.json","w") as f: json.dump({"images":images,"info":{"author":"xcode","version":1}},f,indent=2)
print("Done!")
