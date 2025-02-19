<template>
  <div class="indicators">
  <div class="tree-container">
    <div class="search-box">
      <input type="text" placeholder="Indikator ..." v-model="searchTerm" @input="filterIndicators" />
      <div class="search-icon"></div>
    </div>

    <div v-for="(node, index) in filteredTreeData" :key="node.id" class="tree-node">
      <div class="topics" @click="toggleChildrenVisibility(index)">
        <h3 class="topic">{{ node.nr }} {{ node.label }}</h3>
        <button class="btn-toggle">
          {{ unfoldedNodes[index] ? "▲" : "▼" }}
        </button>
      </div>

      <div class="indicators" :class="{ visible: unfoldedNodes[index] }">
        <div v-for="indicator in node.filteredIndicators" :key="indicator">
          <p class="indicator-checkbox">
            <input type="checkbox" :value="indicator" v-model="selectedIndicators" :on-change="$store.dispatch('selectedIndicators', selectedIndicators)" />
            <router-link :to="{ name: 'indicator', params: { indicatorId: indicator }}">
              {{ $store.getters.getShortname(indicator) }}
           </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
  <div class="selected-indicators">
      <h3 class="topic">Ausgewählte Indikatoren</h3>
      <div v-for="indicator in selectedIndicators" :key="indicator">
        <label class="indicator-checkbox">
          <input type="checkbox" :value="indicator" v-model="selectedIndicators" :on-change="$store.dispatch('selectedIndicators', selectedIndicators)" />
          {{ $store.getters.getShortname(indicator) }}
        </label>
      </div>
    </div>
</div>

</template>

<script>
import thesaurus from "./thesaurus.json";

export default {
  data() {
    return {
      treeData: [],
      unfoldedNodes: {},
      selectedIndicators: this.$store.state.selectedIndicators,
      searchTerm: "",
      thesaurus: thesaurus,
      filteredTreeData: [],
    };
  },
  mounted() {
    this.loadTreeData();
  },
  methods: {
    loadTreeData() {
      const ids = Object.keys(this.$store.getters.topics);
      this.treeData = ids.map(id => {
        const topic = this.$store.getters.topics[id];
        const indicators = this.$store.getters.topicIndicatorMap();
        return {
          id,
          nr: topic.nr,
          label: topic.name,
          ind: indicators.get(id),
          filteredIndicators: indicators.get(id),
        };
      });

      this.unfoldedNodes = this.treeData.reduce((acc, _, index) => {
        acc[index] = false;
        return acc;
      }, {});

      this.filteredTreeData = [...this.treeData];
    },

    toggleChildrenVisibility(index) {
      this.$set(this.unfoldedNodes, index, !this.unfoldedNodes[index]);
    },

    filterIndicators() {
      if (!this.searchTerm) {
        this.filteredTreeData = [...this.treeData];
        Object.keys(this.unfoldedNodes).forEach(index => this.unfoldedNodes[index] = false);
      } else {
        const searchLower = this.searchTerm.toLowerCase();
        
        this.filteredTreeData = this.treeData.map((node, index) => {
            const matchingIndicators = node.ind.filter(indicator => this.matchIndicator(indicator, searchLower)) || this.selectedIndicators.includes(indicator);
            if (matchingIndicators.length > 0) {
              this.unfoldedNodes[index] = true;
              return { ...node, filteredIndicators: matchingIndicators };
            }
            return null;
          }).filter(node => node !== null);
      }
    },

    filteredIndicators(indicators) {
      if(!this.searchTerm){
        return indicators;
      }
      const searchLower = this.searchTerm.toLowerCase();

      return indicators.filter((indicator) => this.matchIndicator(indicator, searchLower));
    },

    matchIndicator(indicator, searchLower){
      const shortName = this.$store.getters.getShortname(indicator).toLowerCase();
      
      if(shortName.includes(searchLower)){
        return true;
      }

      for(const [key, synonyms] of Object.entries(this.thesaurus))
      {
        if(key.toLowerCase() === shortName){
          for(const s of synonyms) 
          {
              if(s.toLowerCase().includes(searchLower)){
                return true;
              }
          }
        }
      }

      return false;
    }
  },
};
</script>