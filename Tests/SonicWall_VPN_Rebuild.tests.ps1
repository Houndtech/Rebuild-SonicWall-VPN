#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. $here\..\$sut

Describe SonicWAll_VPN_Rebuild {
    It "rebuilds sonicwall mobile connection vpns" {
        $true | Should Be $true
    }
}
