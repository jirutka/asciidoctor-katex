(function (Opal) {
  function initialize (Opal) {
//OPAL-GENERATED-CODE//
  }

  var mainModule

  function resolveModule (name) {
    if (!mainModule) {
      checkAsciidoctor()
      initialize(Opal)
      mainModule = Opal.const_get_qualified(Opal.Asciidoctor, 'Katex')
    }
    if (!name) {
      return mainModule
    }
    return Opal.const_get_qualified(mainModule, name)
  }

  function checkAsciidoctor () {
    if (typeof Opal.Asciidoctor === 'undefined') {
      throw new TypeError('Asciidoctor.js is not loaded')
    }
  }

  /**
   * @param {Object} opts
   * @param opts.katex The katex object to use for rendering.
   *   Defaults to `require('katex')`.
   * @param {boolean} opts.requireStemAttr `true` to not process math expressions
   *   when `stem` attribute is not declared, `false` to process anyway.
   *   Defaults to `true`.
   * @param {Object} opts.katexOptions The default options for `katex.render()`.
   *   Defaults to empty object.
   * @return A new instance of `Asciidoctor::Katex::Treeprocessor`.
   */
  function TreeProcessor (opts) {
    opts = opts || {}

    var KatexAdapterClass = resolveModule('OpalKatexAdapter')
    var TreeprocessorClass = resolveModule('Treeprocessor')

    var katex = opts.katex || require('katex')
    var adapter = KatexAdapterClass.$new(Opal.hash(opts.katexOptions || {}), katex)

    return TreeprocessorClass.$new(Opal.hash({
      require_stem_attr: opts.requireStemAttr || true,
      katex_renderer: adapter,
    }))
  }

  /**
   * @return A new instance of `Asciidoctor::Katex::Postprocessor`.
   */
  function PostProcessor () {
    return resolveModule('Postprocessor').$new()
  }

  /**
   * @return {string} Version of this extension.
   */
  function getVersion () {
    return resolveModule().$$const.VERSION.toString();
  }

  /**
   * Creates and configures the Katex extension and registers it into the given
   * extensions registry.
   *
   * @param registry The Asciidoctor extensions registry to register this
   *   extension into. Defaults to the global Asciidoctor registry.
   * @param {Object} opts See {TreeProcessor} (optional).
   * @throws {TypeError} if the *registry* is invalid or Asciidoctor.js is not loaded.
   */
  function register (registry, opts) {
    if (!registry) {
      checkAsciidoctor()
      registry = Opal.Asciidoctor.Extensions
    }
    var treeProcessor = TreeProcessor(opts)
    var postProcessor = PostProcessor()

    // global registry
    if (typeof registry.register === 'function') {
      registry.register(function () {
        this.treeProcessor(treeProcessor)
        this.postprocessor(postProcessor)
      })
    // custom registry
    } else if (typeof registry.block === 'function') {
      registry.treeProcessor(treeProcessor)
      registry.postprocessor(postProcessor)
    } else {
      throw new TypeError('Invalid registry object')
    }
    return registry
  }

  var facade = {
    TreeProcessor: TreeProcessor,
    PostProcessor: PostProcessor,
    getVersion: getVersion,
    register: register,
  }

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = facade
  }
  return facade
})(Opal);
