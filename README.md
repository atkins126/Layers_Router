

#  Layers_Router - Library 

Framework para criação de Camadas de Rotas de Telas para FMX(Test) e VCL

O  Layers_Router - Library tem o objetivo de facilitar a chamada de telas sendo TForm ou TFrame e embed de Layouts em aplicações FMX, e Panels em aplicações VCL, reduzindo o acoplamento das telas de dando mais dinâmismo e práticidade na construção de interfaces ricas em Delphi

## Instalação

Basta registrar no Library Path do seu Delphi o caminho da pasta SRC da Biblioteca

## Primeiros Passos - Tutorial

Para utilizar o  Layers_Router - Library para criar suas rotas, você deve realizar a uses do Layers_Router.

#### Observação:

Dentro da pasta src contém o Layers_Router.inc, esse arquivo possui a diretiva de compilação para o Firemonkey, com essa diretiva comentada o Framework terá suporte a VCL, e ao descomentar você terá suporte ao FMX.

## Criação de uma Tela para Rotas

Para que o sistema  de Rotas funcione você deve criar um novo formulário FMX ou VCL e Implementar a Interface ILayers_RouterComponent ela pertence a unit Layers_Router.Interfaces portanto a mesma deve ser incluida nas suas Units.

Toda a construção das telas baseadas em rotas utilizar TLayout e TPanel para embedar as chamadas das telas, dessa forma é preciso que sua nova tela tenha um TLayout ou um TPanel principal e todos os demais componentes devem ser incluídos dentro deste Layout ou Panel.

#### Implementação em VCL

A Implementação da Interface ILayers_RouterComponent requer a declaração de Três métodos ( RendTheForm, RendTheFrame e UnRender ), o RendTheForm ou RendTheFrame é chamado sempre que uma rota aciona a tela, e o UnRender sempre que ela saí de exibição. 

```
>  RendTheForm: so é chamado quando sua Classe realmente for um Form da classe TForm;
>  RendTheFrame: so é chamado quando sua Classe realmente for um Frames da classe TFrame;
```  

#### Exemplo em VCL

Crie um Novo Formulario na sua Aplicação, inclua nele um Panel alinhado AlClient e implemente os métodos como abaixo.

Lembre-se esta tela é que vai ser renderizado na qual a tela for Principal.

```delphi
unit Template;

interface

uses
  System.SysUtils, 
  System.Types, 
  System.UITypes, 
  System.Classes, 
  System.Variants,

  // Layers_Router Library
  Layers_Router.Interfaces;

type
  TTemplate = class(TForm, ILayers_RouterComponent)
  private
    { Private declarations }
  public
    { Public declarations }
    function RendTheForm : TForm;
    function RendTheFrame : TFrame;
    procedure UnRender;
  end;

var
  Template : TTemplate;

{$R *.dfm}

{ TTemplate }

function TTemplate.RendTheForm: TForm;
begin
  Result := Self; // Só da Result.Self, se a sua tela for um TForm;
end;

function TTemplate.RendTheFrame: TFrame;
begin
  Result := Self; // Só da Result.Self, se a sua tela for um TFrame;
end;

procedure TTemplate.UnRender;
begin

end;

end.
```

Perceba que no método RendTheForm ou RendTheFrame nós definimos o Result como Self, isso é necessário pois ele precisa de um retorno TForm ou TFrame, será embedado sempre que a rota for acionada. 

#### Implementação em FMX

A Implementação da Interface ILayers_RouterComponent requer a declaração de dois métodos ( Render e UnRender ), o Render é chamado sempre que uma rota aciona a tela, e o UnRender sempre que ela saí de exibição. 

Abaixo o Código de uma tela simples implementando a interface ILayers_RouterComponent e pronta para ser utilizada.

#### Exemplo em FMX

Crie um Novo Formulario na sua Aplicação, inclua nele um Layout alinhado AlClient e implemente os métodos como abaixo.

Lembre-se esta tela é que vai ser renderizado na qual a tela for Principal.

```delphi
unit Template;

interface

uses
  System.SysUtils, 
  System.Types, 
  System.UITypes, 
  System.Classes, 
  System.Variants,
  FMX.Types, 
  FMX.Controls, 
  FMX.Forms, 
  FMX.Graphics, 
  FMX.Dialogs,
  Layers_Router.Interfaces;

type
  TTemplate = class(TForm, ILayers_RouterComponent)
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
    function Render : TFMXObject;
    procedure UnRender;
  end;

var
  Template : TTemplate;

implementation

{$R *.fmx}

{ TTemplate }

function TTemplate.Render: TFMXObject;
begin
  Result := Layout1;
end;

procedure TTemplate.UnRender;
begin

end;

end.
```

Perceba que no método Render nós definimos como Result o Layout1, isso é necessário pois esse layout será embedado sempre que a rota for acionada.

## Registrando a Rota para a Tela


Agora que já temos uma tela pronta para ser registrada vamos ao processo que deixará a nossa tela pronta para ser acionada a qualquer momento.

Para registrar uma rota é necessário declarar a uses Layers_Router ela fornece acesso a todos os métodos da biblioteca e em muito dos casos será o único acoplamento necessário nas suas Views.


```delphi
>  uses Layers_Router;
```    


Uma vez declarada basta acionar o método abaixo para declarar o Form ou Frame que criamos anteriormente como uma rota.


```delphi
>  TLayers_Router.Switch.Router('Inicio', TStandards_Principal);
```    

Para facilitar mais a nossa aplicação, você pode criar uma nova Unit Separada no caso uma classe, somente para Registrar as rotas ou então chamar um metodo no onCreate do seu formulario principal para isso.


```delphi
unit Routers;

interface

type
  TRouters = class
    private
    public
      constructor Create;
      destructor Destroy; override;
  end;

var
  Router : TRouters;

implementation

{ TRouter }

uses
  Layers_Router,
  TTemplate,
  TTest1,


constructor TRouters.Create;
begin
  TLayers_Router
    .Switch
      .Router('Template', TTemplate)
{
      .Router('Test', TTest)
      .Router('Test', TTest)
}
      .Router('Test1', TTest1);
end;

destructor TRouters.Destroy;
begin

  inherited;
end;

initialization
  Router := TRouters.Create;

finalization
  Router.Free;
  
end.
```

Repare que nos temos uma variavél Router que é uma variavél global e temos método initialization e finalization dentro nos definimos Router que vai ser responsavel de criar rotas ou destruir quando for necessário.

Pronto já temos uma Classe de Rota criada, dessa forma os nossos Forms ou Frames não precisam mais conhecer a uses da nossa tela, basta acionar nosso sistema de rotas e pedir o nome da rota ex: 'Template' que foi instanciado pela Classe TRouters que será exibida no Layout_Main ou Panel_Main da aplicação.

## Definindo o Render Principal

Já temos uma tela e uma rota para utilizarmos, agora precisamos definir apenas onde está rota renderizará o Layout ou Panel, ou seja, qual será o nosso Objeto que vai receber as telas embedadas.

Para isso no formulário principal da sua aplicação, declare a uses Layers_Router e no onCreate do mesmo faça a seguinte chamada.

Lembrando que no passo anterior se nós tinhamos usado o onCreate do formulário principal para Registrar a Rota.

```delphi  
>  TLayers_Router.Switch.Router('Inicio', TPrimeiraTela);

>  TLayers_Router.Render<TPrimeiraTela>.SetElement(Layout1, Layout1);
```
Se não.

```
>  TLayers_Router.Render<TPrimeiraTela>.SetElement(Layout1, Layout1);
```

O método Render é responsável por definir na biblioteca quais serão os Layouts_Main ou Panel_Main e Index da Aplicação.

O Render recebe como genéric o nome da Classe da nossa tela inicial, ela será renderizada quando a aplicação abrir dentro do Layout ou Panel que foi informado como primeiro parametro do SetElement

O primeiro parametro do SetElement está definindo em qual Layout ou Panel a biblioteca irá renderizar uma nova tela sempre que um Link da rota for chamado.

O Segundo parametro do SetElement está definindo qual é o layout Index da aplicação, assim quando um IndexLink for chamado ele será renderizado nesse layout, mais para frente explicarei sobre o IndexLink.

Pronto, agora ao abrir a sua aplicação você já terá o Layout do Formulario TPrimeiraTela sendo renderizado dentro do Layout ou Panel do formulário principal da sua aplicação.

## Acionando a nova tela atráves da Rota utilizando o Link

Agora vamos supor que tenha mais uma tela se chama TSegundaTela e se quer que volte na TPrimeiraTela apartir de um botão, de lá vamos usar o sistema de Links do Layers_Router para chamar a TSegundaTela sem precisar dar uses nela.

Basta chamar o método abaixo no Evento de Clique do Botão.

```delphi
procedure TPrimeiraTela.Button1Click(Sender: TObject);
begin
  TLayers_Router.Link.&Throw('Tela2');
end;
```

Perceba que a TPrimeiraTela não conhece a TSegundaTela pois o uses da mesma foi dado apenas no Standards_Principal onde é necessário para o Registro das Rotas.

Se você deseja deixar isso mais organizado, eu sugiro inclusive que você crie uma Unit separada apenas para registro das Rotas com um class procedure e faça a chamada desse método no onCreate do Standards_Principal.

Dessa forma damos fim a um monte de referencias cruzadas e acoplamento entre as telas.

## RECURSOS - RENDER

```delphi
TLayers_Router.Render<T>.SetElement(MainContainer, IndexContainer);
```

O Render é a primeira ação a ser feita para trabalhar com o Layers_Router, pois nele você irá configurar os container main e index.

MainContainer = O container onde os formularios serão embedados

IndexContainer = O container principal da aplicação (util quando você tem mais de um tipo de Layout ou Panel na aplicação)

## SWITCH

```delphi
TLayers_Router.Switch.Router(aPath : String; aRouter : TPersistentClass);
```
No Switch você registra suas rotas, passando o nome da rota e o objeto que seja aberto quando essa rota for acionada.

```delphi
TLayers_Router.Switch.Router(aPath : String; aRouter : TPersistentClass; aSidebarKey : String = 'SBIndex'; isVisible : Boolean = True);
```

No Swith existem alguns parametros a mais que já possuem valores default

aSidebarKey: Este parametro permite você separar as rotas por categoria para a criação de menus dinâmicos com a classe SideBar, vou explicar mais abaixo sobre ela.

isVisible: Permite você ocultar a rota na geração dinamica dos menus com a SideBar.

## LINK

```delphi
TLayers_Router.Link.&Throw ( APatch : String; AComponent : TFMXObject );

TLayers_Router.Link.&Throw ( APatch : String);
    
TLayers_Router.Link.&Throw ( APatch : String; APropersys : TPropersys; AKey : String = '');
```

Os links são as ações para acionar as rotas que você registrou no Switch

Existem 3 formas de chamar os links:

```delphi
TLayers_Router.Link.&Throw ( APatch : String);
```
Passando apenas o Path da Rota, dessa forma o formulario associado a rota será embedado dentro do MainContainer que você definiu no Render

```delphi
TLayers_Router.Link.&Throw ( APatch : String; AComponent : TFMXObject );
```

Passando o Path e o Component, ele irá embedar o formulario registrado no path dentro do componente que você está passando no parametro.

```delphi
TLayers_Router.Link.&Throw ( APatch : String; APropersys : TPropersys; AKey : String = '');
```

Você pode acionar uma rota passando Propersys, que são valores que o seu formulário irá receber no momento do Render, vou explicar mais abaixo como isso funciona em detalhes, mas isso é util por exemplo quando você deseja enviar um ID para uma tela realizar uma consulta no banco e ser carregada com os dados.

## PROPERSYS

```delphi
TLayers_Router.Link.&Throw ( APatch : String; APropersys : TPropersys; AKey : String = '');
```

A Biblioteca Layers_Router incopora o Delphi Event Bus para realizar ações de Pub e Sub, com isso você pode registrar seus formularios para receber eventos na chamada dos links.

Para receber uma APropersys você precisa adicionar a uses Layers_Router.Propersys no seu formulario e implementar o seguinte método com o atributo [Subscribe]

```delphi
[Subscribe]
procedure Propersys ( AValue : TPropersys);
```

e implementa-lo 

```delphi
procedure TPageCadastros.Propersys(AValue: TPropersys);
begin
    if AValue.Key = 'telacadastro' then
        Label1.Text := AValue.PropString;
  AValue.Free;
end;
```
Dessa forma seu formulario está preparado por exemplo para receber uma string passada na chamada do link.

Para chamar um link passando um Propersys você utiliza o seguinte código:

```delphi
TLayers_Router.Link.&Throw('Cadastros', TPropersys.Create.ProprsString('Olá').Key('telacadastro'));
```
Passando no Link o objeto TPropersys com uma ProprsString e uma Chave para que a tela que vai receber tenha certeza que aquela Propersys foi enviada para ela.

## SideBar

Com as rotas registradas você pode criar um menu automático das rotas registradas de forma dinâmica, basta registrar uma nova rota que a mesma estará disponível em todos os seus menus.

```delphi
TLayers_Router
    .SideBar
      .MainContainer(Layout5)
      .LinkContainer(Layout4)
      .FontSize(15)
      .FontColor(4294967295)
      .ItemHeigth(60)
    .RenderToListBox;
```

No exemplo acima estamos gerando um menu em formato de listbox dentro do Layout5 e todos os links clicados nesse menu serão renderizados no Layout, se você não passar o LinkContainer o mesmo será renderizado no MainContainer informado no Render do Layers_Router.

Você ainda pode criar menus baseados em rotas categorizadas, basta no registro da rota você informar a categoria que a rota pertence

```delphi
TLayers_Router.Switch.Router('Clientes', TPagePrincipal, 'cadastros');
  TLayers_Router.Switch.Router('Fornecedores', TSubCadastros, 'cadastros');
  TLayers_Router.Switch.Router('Produtos', TSubCadastros, 'cadastros');
```

Dessa forma criamos 3 rotas da categoria cadastro, para gerar um menu apenas com esses link basta informar isso na construção da SideBar.

```delphi
TLayers_Router
    .SideBar
      .Name('cadastros')
      .MainContainer(Layout5)
      .LinkContainer(Layout4)
      .FontSize(15)
      .FontColor(4294967295)
      .ItemHeigth(60)
    .RenderToListBox;
```
