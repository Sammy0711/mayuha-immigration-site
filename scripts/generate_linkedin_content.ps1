$ErrorActionPreference = 'Stop'

$baseDir = 'C:\mayuha-automation\linkedin'
New-Item -Path $baseDir -ItemType Directory -Force | Out-Null

# -------------------------
# 1) linkedin-profile.json
# -------------------------
$headlineEn = 'AI-Powered Administrative Scrivener | Japan Company Formation & Visa Services'
$headlineJp = 'AI活用 行政書士｜日本での会社設立・ビザ申請支援'

$aboutEn = @'
I help international founders, executives, and investors launch and scale in Japan with precision, speed, and confidence. Whether you are registering a K.K. or G.K., opening a bank account, obtaining a Business Manager Visa, or restructuring after investment, I guide you through every step with bilingual clarity and regulatory accuracy. As a licensed Administrative Scrivener (Gyoseishoshi), I bring 15+ years of cross-border practice and a proven record of 500+ successful company formations, visa approvals, and corporate changes.

My approach blends deep legal-operational expertise with AI-driven delivery. Drafting, translation, and compliance checks are automated and quality-controlled, enabling standard incorporations and common visa applications to be completed within 48 hours. You get fewer back-and-forths, cleaner document sets, and predictable outcomes. I partner closely with tax accountants, judicial scriveners, and banks to ensure end-to-end readiness—from articles of incorporation and seal registration to tax filings and payroll onboarding.

Clients choose me for strategic insight as much as execution. I advise on entity selection (K.K. vs G.K.), share structure, capital planning, director residency, registered address, and governance frameworks fit for fundraising and M&A. For immigration, I structure robust business plans, revenue models, and hiring roadmaps that satisfy examiners while supporting long-term growth. Clear timelines, fixed-fee options, and transparent checklists keep your team aligned. If you need a reliable, tech-enabled partner for Japan entry or expansion, I am ready to deliver fast, compliant results.
'@

$aboutJp = @'
海外企業・起業家・投資家の日本進出を、正確かつ迅速に伴走支援します。K.K.（株式会社）やG.K.（合同会社）の設立、銀行口座開設、ビジネスマネージャー在留資格の取得、投資後の組織再編まで、日英バイリンガルで要点を整理し、手戻りのない形で前進させます。行政書士として15年以上の実務経験、累計500件超の会社設立・在留資格許可・各種変更手続の実績にもとづき、実務と審査基準の双方に強い支援を提供します。

AIを組み込んだワークフローにより、ドラフト作成・訳文整備・適法性チェックを自動化し、標準的な案件は最短48時間で完了可能。やり取りを最小化しつつ、整った書類一式を短時間でご用意します。税理士・司法書士・金融機関とも連携し、定款・印鑑届・各種届出から税務・給与まで、ワンストップで立ち上げを支援します。

会社設立では、K.K./G.K.の選択、株式・持分設計、資本金計画、役員要件、住所・ガバナンス体制など、資金調達やM&Aを見据えた構成をご提案。ビザでは、事業計画・売上モデル・採用計画を審査目線で再設計し、実現可能性と持続性をバランス良く示します。明確なスケジュール、固定報酬の選択肢、透明なチェックリストで、関係者の合意形成を素早く進めます。日本展開の確度とスピードを両立したい方は、ぜひご相談ください。
'@

$profile = [ordered]@{
  headline = [ordered]@{ en = $headlineEn; jp = $headlineJp };
  about    = [ordered]@{ en = $aboutEn;    jp = $aboutJp };
  services = @(
    [ordered]@{
      name = 'Company formation'; name_jp = '会社設立'; priority = 1;
      description_en = 'Complete incorporation for KK or GK, governance setup, bank coordination, seals and registrations. AI assisted drafting with 48 hour turnaround for standard cases.';
      description_jp = '株式会社/合同会社の設立を起点に、機関設計・銀行連携・印鑑/各種届出までを一気通貫で支援。標準案件は48時間での迅速対応に対応。';
    },
    [ordered]@{
      name = 'Visa applications'; name_jp = '在留資格申請'; priority = 2;
      description_en = 'Business Manager, Startup and work visas with evidence led plans, bilingual documentation and examiner aligned narratives for high approval rates.';
      description_jp = '経営・管理、スタートアップ、就労系などの在留資格について、根拠資料と説得力ある計画で高い許可率を目指す申請書類を作成。';
    }
  );
  keywords = @('Japan company setup','business manager visa','startup visa','M&A advisory');
};

$profilePath = Join-Path $baseDir 'linkedin-profile.json'
$profile | ConvertTo-Json -Depth 10 | Set-Content -Path $profilePath -Encoding utf8

# -------------------------
# 2) linkedin-posts.json
# -------------------------
function Get-PostType([int]$index) {
  $types = @('tip','case_study','qa','announcement')
  return $types[($index - 1) % $types.Count]
}

function New-Post {
  param(
    [int]$Id,
    [string]$Topic,
    [int]$Index
  )
  $type = Get-PostType $Index
  $hashtags = @()
  $en = ''
  $jp = ''

  switch ($Topic) {
    'company_formation' {
      switch ($type) {
        'tip' {
          $en = 'Company formation tip #' + $Index + ': Choose K.K. vs G.K. based on investor expectations, governance, and exit options. Draft Articles that support future fundraising and stock grants.'
          $jp = '会社設立のヒント #' + $Index + '：投資家の期待・ガバナンス・将来のEXITを踏まえ、K.K.かG.K.を選択。将来の資金調達やストックグラントに耐える定款設計を。'
        }
        'case_study' {
          $en = 'Case study #' + $Index + ': Foreign SaaS team incorporated a G.K. in 48 hours. Defined capital, prepared bilingual minutes, and aligned bank KYC upfront to avoid delays.'
          $jp = '事例 #' + $Index + '：海外SaaSチームが合同会社を48時間で設立。資本金設計、議事録のバイリンガル整備、銀行KYCを事前調整し待ち時間を最小化。'
        }
        'qa' {
          $en = 'Q&A #' + $Index + ': Q: Can one director live outside Japan? A: Yes for K.K., but consider bank expectations and resident manager needs for operations.'
          $jp = 'Q&A #' + $Index + '：Q：取締役が全員海外在住でも良い？ A：K.K.は可能。ただし銀行の期待値や日常運営での常駐体制を考慮。'
        }
        'announcement' {
          $en = 'Announcement: 48-hour incorporation window for standard K.K./G.K. remains available this month. Fixed-fee options and bilingual deliverables included.'
          $jp = 'お知らせ：標準的なK.K./G.K.設立の48時間対応枠を今月も提供。固定報酬プランと日英ドキュメントを含みます。'
        }
      }
      $hashtags = @('#JapanBusiness','#CompanyFormation','#JapanCompanySetup','#KK','#GK','#行政書士','#起業','#日本進出')
    }
    'visa' {
      switch ($type) {
        'tip' {
          $en = 'Visa tip #' + $Index + ': For Business Manager, align capital, office lease, and revenue plan with documented evidence. Consistency across contracts and ledgers matters.'
          $jp = 'ビザのヒント #' + $Index + '：経営・管理は資本金・事務所契約・収益計画の整合性が要。契約書や台帳の整合を証拠で示すのが鍵。'
        }
        'case_study' {
          $en = 'Case study #' + $Index + ': Startup Visa to Business Manager transition completed smoothly with a milestone-driven plan and early facility contracts.'
          $jp = '事例 #' + $Index + '：スタートアップビザから経営・管理へ円滑に移行。マイルストーン型計画と早期の施設契約で審査をクリア。'
        }
        'qa' {
          $en = 'Q&A #' + $Index + ': Q: Can I apply before revenue? A: Yes, if the plan, hiring, and capital show feasibility and continuity under the guidelines.'
          $jp = 'Q&A #' + $Index + '：Q：売上が出る前に申請できる？ A：可能。計画・採用・資本の実現可能性と継続性をガイドラインに沿って示すこと。'
        }
        'announcement' {
          $en = 'Announcement: Bilingual review service for Business Manager Visa packages now includes AI-based completeness checks to reduce rework.'
          $jp = 'お知らせ：経営・管理ビザ書類のバイリンガルレビューにAI自動チェックを追加。手戻りを削減。'
        }
      }
      $hashtags = @('#BusinessManagerVisa','#StartupVisa','#WorkVisa','#在留資格','#日本')
    }
    'ai_automation' {
      switch ($type) {
        'tip' {
          $en = 'AI tip #' + $Index + ': Use AI to pre-validate incorporation data, detect inconsistencies, and accelerate bilingual drafting without sacrificing compliance.'
          $jp = 'AI活用ヒント #' + $Index + '：設立データの事前検証や不整合の検出、日英ドラフトの加速にAIを活用。適法性とスピードを両立。'
        }
        'case_study' {
          $en = 'Case study #' + $Index + ': AI-assisted workflow reduced a nine-document visa packet review from 5 hours to 40 minutes with higher consistency.'
          $jp = '事例 #' + $Index + '：AI支援により9種のビザ書類レビューが5時間→40分に短縮。整合性も向上。'
        }
        'qa' {
          $en = 'Q&A #' + $Index + ': Q: Does AI replace legal review? A: No. It augments experts with faster checks and cleaner drafts; final judgment stays human.'
          $jp = 'Q&A #' + $Index + '：Q：AIは法的レビューを置き換える？ A：いいえ。専門家の判断を補強し、確認とドラフト品質を高める補助です。'
        }
        'announcement' {
          $en = 'Announcement: All standard cases now include AI-driven consistency checks and translation QA at no extra cost.'
          $jp = 'お知らせ：標準案件すべてでAI整合チェックと翻訳QAを追加費用なしで提供。'
        }
      }
      $hashtags = @('#AI','#Automation','#LegalTech','#OpenAI','#業務自動化')
    }
  }

  return [ordered]@{
    id = $Id; topic = $Topic; type = $type
    en_text = $en; jp_text = $jp; hashtags = $hashtags
  }
}

$posts = @()
$nextId = 1
for ($i = 1; $i -le 60; $i++) { $posts += New-Post -Id $nextId -Topic 'company_formation' -Index $i; $nextId++ }
for ($i = 1; $i -le 30; $i++) { $posts += New-Post -Id $nextId -Topic 'visa' -Index $i; $nextId++ }
for ($i = 1; $i -le 10; $i++) { $posts += New-Post -Id $nextId -Topic 'ai_automation' -Index $i; $nextId++ }

$postsPath = Join-Path $baseDir 'linkedin-posts.json'
$posts | ConvertTo-Json -Depth 10 | Set-Content -Path $postsPath -Encoding utf8

# -------------------------
# 3) posting-schedule.json
# -------------------------
$times = @('09:00','15:00','21:00')
$schedule = @()
$postIndex = 0
for ($day = 1; $day -le 30; $day++) {
  $slots = @()
  foreach ($t in $times) {
    $postId = ($postIndex % $posts.Count) + 1
    $slots += [ordered]@{ time = $t; timezone = 'Asia/Tokyo'; post_id = $postId }
    $postIndex++
  }
  $schedule += [ordered]@{ day = $day; slots = $slots }
}

$schedulePath = Join-Path $baseDir 'posting-schedule.json'
$schedule | ConvertTo-Json -Depth 10 | Set-Content -Path $schedulePath -Encoding utf8

Write-Host 'Files generated:'
Write-Host $profilePath
Write-Host $postsPath
Write-Host $schedulePath


